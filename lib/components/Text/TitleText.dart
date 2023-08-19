import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TitleText({super.key, required this.title, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context).textTheme.titleMedium?.merge(style),
        textAlign: textAlign ?? TextAlign.center);
  }
}
