import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final TextAlign? textAlign;

  Subtitle({super.key, required this.title, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)
            .merge(style),
        textAlign: textAlign ?? TextAlign.center);
  }
}
