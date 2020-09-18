library tenor_picker;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tenor_picker/src/model/tenor_client.dart';
import 'package:tenor_picker/src/widgets/tenor_context.dart';
import 'package:tenor_picker/src/widgets/tenor_search_page.dart';
export 'package:tenor_picker/src/model/tenor_client.dart';
export 'package:tenor_picker/src/widgets/tenor_image.dart';

typedef ErrorListener = void Function(dynamic error);

/// Provides Giphy picker functionality.
class TenorPicker {
  /// Renders a full screen modal dialog for searching, and selecting a Giphy image.
  static Future<TenorGif> pickGif({
    @required BuildContext context,
    @required String apiKey,
    @required AppBar appBar,
    Widget title,
    IconThemeData actionsIconTheme,
    IconThemeData iconTheme,
    Brightness brightness,
    ErrorListener onError,
    bool showPreviewPage = true,
    String searchText = 'Search GIFs',
  }) async {
    TenorGif result;

    await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        context: context,
        isScrollControlled: true,
        builder: (context) => TenorContext(
              child: TenorSearchPage(
                appBar: appBar,
                title: title,
                actionsIconTheme: actionsIconTheme,
                iconTheme: iconTheme,
                brightness: brightness,
              ),
              apiKey: apiKey,
              onError: onError ?? (error) => _showErrorDialog(context, error),
              onSelected: (gif) {
                result = gif;

                // pop preview page if necessary
                if (showPreviewPage) {
                  Navigator.pop(context);
                }
                // pop giphy_picker
                Navigator.pop(context);
              },
              showPreviewPage: showPreviewPage,
              searchText: searchText,
            ));
    return result;
  }

  static void _showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Giphy error'),
          content: new Text('An error occurred. $error'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
