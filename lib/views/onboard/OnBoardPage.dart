import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/config/keys.dart';
import 'package:gf_mobile/config/onboard_data.dart';
import 'package:gf_mobile/models/Onboard/OnboardModel.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        duration: const Duration(milliseconds: 700),
        colors: onBoardData.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        onFinish: () {
          GetStorage().write(isOnboarded, true);
          Get.offAllNamed("/home");
        },
        // curve: Curves.fastOutSlowIn,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 2), // visual center
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.1,
            color: Colors.white,
          ),
        ),
        itemBuilder: (index) {
          final page = onBoardData[index % onBoardData.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final OnBoardModel page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    space(double p) => SizedBox(height: screenHeight * p / 100);
    return Column(
      children: [
        space(10),
        _Image(
          page: page,
          size: 190,
          iconSize: 170,
        ),
        space(8),
        _Text(
          page: page,
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    Key? key,
    required this.page,
    this.style,
  }) : super(key: key);

  final OnBoardModel page;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TitleText(
              title: page.title ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              page.description ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            )
          ],
        ));
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.page,
    required this.size,
    required this.iconSize,
  }) : super(key: key);

  final OnBoardModel page;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final bgColor = page.bgColor
        // .withBlue(page.bgColor.blue - 40)
        .withGreen(page.bgColor.green + 20)
        .withRed(page.bgColor.red - 100)
        .withAlpha(90);

    final icon1Color =
        page.bgColor.withBlue(page.bgColor.blue - 10).withGreen(220);
    final icon2Color = page.bgColor.withGreen(66).withRed(77);
    final icon3Color = page.bgColor.withRed(111).withGreen(220);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(60.0)),
        color: bgColor,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Icon(
            page.image,
            size: iconSize,
            color: icon3Color,
          ),
        ],
      ),
    );
  }
}
