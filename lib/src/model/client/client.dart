import 'dart:async';
import 'dart:convert';

import 'package:giphy_picker/src/model/client/collection.dart';
import 'package:giphy_picker/src/model/client/tenorGif.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class TenorClient {
  static final baseUri = Uri(scheme: "https", host: "api.tenor.com");
  final String _apiKey;
  final Client _client;

  TenorClient({
    @required String apiKey,
    Client client,
  })  : _apiKey = apiKey,
        _client = client ?? Client();

  Future<TenorCategories> categories() async {
    return _fetchCategories(
      baseUri.replace(
        path: 'v1/categories',
      ),
    );
  }

  Future<List<TenorGif>> search(
    String query, {
    int limit = 30,
  }) async {
    return _fetchCollection(
      baseUri.replace(
        path: 'v1/search',
        queryParameters: <String, String>{
          'q': query,
          'limit': '$limit',
        },
      ),
    );
  }

  Future<List<TenorGif>> trending({
    int limit = 30,
  }) async {
    return _fetchCollection(
      baseUri.replace(
        path: 'v1/trending',
        queryParameters: <String, String>{
          'limit': '$limit',
        },
      ),
    );
  }

  Future<List<TenorGif>> random({
    String limit,
  }) async {
    return _fetchCollection(
      baseUri.replace(
        path: 'v1/random',
        queryParameters: <String, String>{
          'limit': '$limit',
        },
      ),
    );
  }

  Future<TenorCategories> _fetchCategories(Uri uri) async {
    final response = await _getWithAuthorization(uri);

    return TenorCategories.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<List<TenorGif>> _fetchCollection(Uri uri) async {
    final response = await _getWithAuthorization(uri);
    List<TenorGif> gifs = [];
    json.decode(response.body)["results"].forEach((gif) {
      gifs.add(TenorGif.fromJson(gif));
    });
    return gifs;
  }

  Future<Response> _getWithAuthorization(Uri uri) async {
    final response = await _client.get(
      uri
          .replace(
            queryParameters: Map<String, String>.from(uri.queryParameters)..putIfAbsent('api_key', () => _apiKey),
          )
          .toString(),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw TenorClientError(response.statusCode, response.body);
    }
  }
}

class TenorClientError {
  final int statusCode;
  final String exception;

  TenorClientError(this.statusCode, this.exception);

  @override
  String toString() {
    return 'TenorClientError{statusCode: $statusCode, exception: $exception}';
  }
}
