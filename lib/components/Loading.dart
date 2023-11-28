import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class GFLoader extends StatelessWidget {
  final Color? dotColor;

  const GFLoader({super.key, this.dotColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        colors:
        dotColor != null ? [dotColor!] : null,
      ),
    );
  }
}
