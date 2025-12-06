import 'package:flutter/material.dart';

class ScreenSubtitle extends StatelessWidget {
  final String text;
  final TextAlign align;

  const ScreenSubtitle({
    super.key,
    required this.text,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}
