import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class GFLoader extends StatelessWidget {
  final Color? dotColor;
  final int? width;

  const GFLoader({super.key, this.dotColor, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? width!.toDouble() : 25,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        colors: dotColor != null ? [dotColor!] : null,
      ),
    );
  }
}
