import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  Line({Key key, this.width}) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
    );
  }
}
