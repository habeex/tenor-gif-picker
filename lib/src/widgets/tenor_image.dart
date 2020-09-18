import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tenor_picker/src/model/client/tenorGif.dart';
import 'package:tenor_picker/src/widgets/tenor_overlay.dart';
import 'package:http/http.dart';

/// Loads and renders a Giphy image.
class TenorImage extends StatefulWidget {
  final String url;
  final Widget placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final bool renderGiphyOverlay;

  /// Loads an image from given url.
  const TenorImage(
      {Key key,
      @required this.url,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : super(key: key);

  /// Loads the original image for given Giphy gif.
  TenorImage.original(
      {Key key,
      @required TenorGif gif,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : url = gif.mediaTypes[0].gif.url,
        super(key: key ?? Key(gif.id));

  /// Loads the original still image for given Giphy gif.
  TenorImage.originalStill(
      {Key key,
      @required TenorGif gif,
      this.placeholder,
      this.width,
      this.height,
      this.fit,
      this.renderGiphyOverlay = true})
      : url = gif.url,
        super(key: key ?? Key(gif.id));

  @override
  _TenorImageState createState() => _TenorImageState();

  /// Loads the images bytes for given url from Giphy.
  static Future<Uint8List> load(String url, {Client client}) async {
    assert(url != null);

    final response = await (client ?? Client()).get(url, headers: {'accept': 'image/*'});

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    return null;
  }
}

class _TenorImageState extends State<TenorImage> {
  Future<Uint8List> _loadImage;

  @override
  void initState() {
    _loadImage = TenorImage.load(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _loadImage,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData) {
          final image = Image.memory(snapshot.data, width: widget.width, height: widget.height, fit: widget.fit);

          if (widget.renderGiphyOverlay) {
            return TenorOverlay(child: image);
          }
          return image;
        }
        return widget.placeholder ?? Center(child: CircularProgressIndicator());
      });
}
