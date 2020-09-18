import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/tenor_search_view.dart';

class TenorSearchPage extends StatelessWidget {
  final Widget title;

  const TenorSearchPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: title), body: SafeArea(child: TenorSearchView(), bottom: false));
  }
}
