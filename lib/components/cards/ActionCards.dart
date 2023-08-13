import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gf_mobile/components/Text/CardTitle.dart';
import 'package:line_icons/line_icon.dart';

class ActionCards extends StatelessWidget {

  final String title;
  final String value;
  final IconData? icon;
  final bool isSvg;
  final String assetName;

  const ActionCards({super.key, required this.title, required this.value, this.icon, this.isSvg = false, this.assetName = ""});

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
        elevation: 5,
        shadowColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    !isSvg ? SizedBox(
                      height: 22,
                      child: LineIcon(
                        icon!,
                        color: Colors.yellow.shade800,
                      ),
                    ) : SvgPicture.asset(assetName, height: 22, color: Colors.yellow.shade800,),
                  const SizedBox(height: 8),
                  CardTitle(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ), title: title,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
