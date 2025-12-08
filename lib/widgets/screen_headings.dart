import 'package:flutter/material.dart';

class ScreenHeading extends StatelessWidget {
  final String text;
  final TextAlign align;

  const ScreenHeading({
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

class TitleText extends StatelessWidget {
  final String text;
  final TextAlign align;

  const TitleText({
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
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
