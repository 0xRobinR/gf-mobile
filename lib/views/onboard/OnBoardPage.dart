import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/config/keys.dart';
import 'package:gf_mobile/config/onboard_data.dart';
import 'package:gf_mobile/models/Onboard/OnboardModel.dart';
import 'package:gf_mobile/routes.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.black,
        finishButtonText: "Let's Go",
        finishButtonStyle: FinishButtonStyle(backgroundColor: Colors.red),
        finishButtonTextStyle:
            GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        skipTextButton: Text(
          'Skip',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          'What is Greenfield?',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        ),
        onFinish: () {
          GetStorage().write(isOnboarded, true);
          Get.offAllNamed(Routes.home);
        },
        background: onBoardData.map((e) => const Text("")).toList(),
        totalPage: 3,
        speed: 1,
        pageBodies: onBoardData
            .map((e) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 80,
                      ),
                      Text(e.title),
                      const SizedBox(
                        height: 20,
                      ),
                      Icon(
                        e.image,
                        size: 120,
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      Text(e.description),
                    ],
                  ),
                ))
            .toList(),
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
