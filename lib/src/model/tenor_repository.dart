import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:tenor_picker/src/model/repository.dart';
import 'package:tenor_picker/tenor_picker.dart';

import 'package:http/http.dart' as http;

typedef Future<List<TenorGif>> GetCollection(TenorClient client, int offset, int limit);

/// Retrieves and caches gif collections from Giphy.
class TenorRepository extends Repository<TenorGif> {
  final _client = http.Client();
  final _previewCompleters = HashMap<int, Completer<Uint8List>>();
  final _previewQueue = Queue<int>();
  final GetCollection getCollection;
  final int maxConcurrentPreviewLoad;
  TenorClient _giphyClient;
  int _previewLoad = 0;

  TenorRepository(
      {@required String apiKey,
      @required this.getCollection,
      this.maxConcurrentPreviewLoad = 4,
      int pageSize = 25,
      ErrorListener onError})
      : super(pageSize: pageSize, onError: onError) {
    assert(getCollection != null);
    assert(maxConcurrentPreviewLoad != null);
    _giphyClient = TenorClient(apiKey: apiKey, client: _client);
  }

  /// Retrieves specified page of gif data from Giphy.
  Future<Page<TenorGif>> getPage(int page) async {
    final offset = page * pageSize;
    final collection = await getCollection(_giphyClient, offset, pageSize);
    return Page(collection, page, 25);
  }

  /// Retrieves a preview Gif image at specified index.
  Future<Uint8List> getPreview(int index) async {
    assert(index != null);

    var completer = _previewCompleters[index];
    if (completer == null) {
      completer = Completer<Uint8List>();
      _previewCompleters[index] = completer;
      _previewQueue.add(index);

      // initiate next load
      _loadNextPreview();
    }

    return completer.future;
  }

  /// Cancels retrieving specified preview image, by removing it from the queue.
  void cancelGetPreview(int index) {
    assert(index != null);

    final completer = _previewCompleters.remove(index);
    if (completer != null) {
      // remove from queue
      _previewQueue.remove(index);

      // and complete with null
      completer.complete(null);
    }
  }

  void _loadNextPreview() {
    if (_previewLoad < maxConcurrentPreviewLoad && _previewQueue.isNotEmpty) {
      _previewLoad++;

      final index = _previewQueue.removeLast();
      final completer = _previewCompleters.remove(index);
      if (completer != null) {
        get(index).then(_loadPreviewImage).then((bytes) {
          if (!completer.isCompleted) {
            completer.complete(bytes);
          }
        }).whenComplete(() {
          _previewLoad--;
          _loadNextPreview();
        });
      } else {
        _previewLoad--;
      }

      _loadNextPreview();
    }
  }

  Future<Uint8List> _loadPreviewImage(TenorGif gif) async {
    // fallback to still image if preview is empty
    final url = gif.mediaTypes[0].nanoGif.url ?? gif.mediaTypes[0].nanoGif.url;
    if (url != null) {
      return await TenorImage.load(url, client: _client);
    }

    return null;
  }

  /// The repository of trending gif images.
  static Future<TenorRepository> trending({@required String apiKey, ErrorListener onError}) async {
    final repo = TenorRepository(
        apiKey: apiKey, getCollection: (client, offset, limit) => client.trending(limit: limit), onError: onError);

    // retrieve first page
    await repo.get(0);

    return repo;
  }

  /// A repository of images for given search query.
  static Future<TenorRepository> search(
      {@required String apiKey, @required String query, bool sticker = false, ErrorListener onError}) async {
    final repo = TenorRepository(
        apiKey: apiKey, getCollection: (client, offset, limit) => client.search(query, limit: limit), onError: onError);

    // retrieve first page
    await repo.get(0);

    return repo;
  }
}
