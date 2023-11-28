import 'package:flutter/material.dart';

import 'Loading.dart';

class AnimatedDotsText extends StatefulWidget {
  final String text;
  final Color? dotColor;
  final double dotRadius;
  final double dotSpacing;
  final Duration animationDuration;

  const AnimatedDotsText({
    super.key,
    required this.text,
    this.dotColor,
    required this.dotRadius,
    required this.dotSpacing,
    required this.animationDuration,
  });

  @override
  State<AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<AnimatedDotsText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.text, style: TextStyle(color: widget.dotColor)),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GFLoader(
                    dotColor: widget.dotColor,
                  )),
            ],
          ),
        );
      },
    );
  }
}
