import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final TextAlign? textAlign;

  const Subtitle({super.key, required this.title, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70
      ).merge(style),
      textAlign: textAlign ?? TextAlign.center
    );
  }
}
