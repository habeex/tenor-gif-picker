import 'package:flutter/material.dart';
import 'package:tenor_picker/tenor_picker.dart';

/// Provides the context for a Giphy search operation, and makes its data available to its widget sub-tree.
class TenorContext extends InheritedWidget {
  final String apiKey;

  final ValueChanged<TenorGif> onSelected;
  final ErrorListener onError;
  final bool showPreviewPage;
  final String searchText;

  const TenorContext({
    Key key,
    @required Widget child,
    @required this.apiKey,
    this.onSelected,
    this.onError,
    this.showPreviewPage = true,
    this.searchText = 'Search Giphy',
  }) : super(key: key, child: child);

  void select(TenorGif gif) {
    if (onSelected != null) {
      onSelected(gif);
    }
  }

  void error(dynamic error) {
    if (onError != null) {
      onError(error);
    }
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static TenorContext of(BuildContext context) {
    final settings = context.getElementForInheritedWidgetOfExactType<TenorContext>()?.widget as TenorContext;

    if (settings == null) {
      throw 'Required GiphyContext widget not found. Make sure to wrap your widget with GiphyContext.';
    }
    return settings;
  }
}
