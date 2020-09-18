import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/tenor_client.dart';
import 'package:giphy_picker/src/widgets/tenor_image.dart';

/// Presents a Giphy preview image.
class TenorPreviewPage extends StatelessWidget {
  final TenorGif gif;
  final Widget title;
  final ValueChanged<TenorGif> onSelected;

  const TenorPreviewPage({@required this.gif, @required this.onSelected, this.title});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
            title: title, actions: <Widget>[IconButton(icon: Icon(Icons.check), onPressed: () => onSelected(gif))]),
        body: SafeArea(
            child: Center(
                child: TenorImage.original(
              gif: gif,
              width: media.orientation == Orientation.portrait ? double.maxFinite : null,
              height: media.orientation == Orientation.landscape ? double.maxFinite : null,
              fit: BoxFit.contain,
            )),
            bottom: false));
  }
}
