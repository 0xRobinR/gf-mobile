import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  CardTitle({super.key, required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.merge(style)
            .merge(TextStyle(fontSize: 14)),
        textAlign: TextAlign.center);
  }
}
