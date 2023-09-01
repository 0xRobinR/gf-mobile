import 'package:animated_flip_counter/animated_flip_counter.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gf_mobile/components/Text/CardTitle.dart';
import 'package:line_icons/line_icon.dart';

class UserCard extends StatelessWidget {
  final String title;
  final double value;
  final bool? isInt;
  final IconData? icon;
  final bool isSvg;
  final String assetName;

  const UserCard(
      {super.key,
      required this.title,
      required this.value,
      this.icon,
      this.isSvg = false,
      this.assetName = "",
      this.isInt = false});

  @override
  Widget build(BuildContext context) {
    double cardWidth = 250; // Default card width

    if (MediaQuery.of(context).size.width >= 600) {
      cardWidth = (MediaQuery.of(context).size.width - 32) / 4;
    } else if (MediaQuery.of(context).size.width >= 400) {
      cardWidth = (MediaQuery.of(context).size.width - 24) / 2.009;
    } else {
      cardWidth = (MediaQuery.of(context).size.width - 16) / 2;
    }

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 1,
        shadowColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardTitle(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    title: title,
                  ),
                  !isSvg
                      ? SizedBox(
                          height: 22,
                          child: LineIcon(
                            icon!,
                            color: Colors.yellow.shade800,
                          ),
                        )
                      : SvgPicture.asset(
                          assetName,
                          height: 22,
                          color: Colors.yellow.shade800,
                        ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedFlipCounter(
                fractionDigits: isInt! ? 0 : 3,
                value: value,
                duration: const Duration(seconds: 1),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
