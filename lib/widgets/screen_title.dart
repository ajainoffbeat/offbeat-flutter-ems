import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String text;
  final TextAlign align;

  const ScreenTitle({
    super.key,
    required this.text,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
