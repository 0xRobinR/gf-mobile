import 'package:flutter/material.dart';

class GFDivider extends StatelessWidget {
  const GFDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: const SizedBox(width: 100, height: 80, child: Divider()));
  }
}
