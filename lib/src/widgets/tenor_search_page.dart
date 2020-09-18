import 'package:flutter/material.dart';
import 'package:tenor_picker/src/widgets/tenor_search_view.dart';

class TenorSearchPage extends StatelessWidget {
  final AppBar appBar;
  final Widget title;
  final IconThemeData actionsIconTheme;
  final IconThemeData iconTheme;
  final Brightness brightness;

  const TenorSearchPage(
      {@required this.appBar, @required this.title, this.actionsIconTheme, this.iconTheme, this.brightness});

  @override
  Widget build(BuildContext context) {
    return TenorSearchView(
      title: title,
      actionsIconTheme: actionsIconTheme,
      iconTheme: iconTheme,
      brightness: brightness,
    );
  }
}
