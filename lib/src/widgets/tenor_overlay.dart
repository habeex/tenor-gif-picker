import 'package:flutter/material.dart';

class TenorOverlay extends StatelessWidget {
  final Widget child;

  const TenorOverlay({this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      child,
      Positioned(left: 0, right: 0, bottom: 0, height: 16, child: IgnorePointer(child: Container()))
    ]);
  }
}
