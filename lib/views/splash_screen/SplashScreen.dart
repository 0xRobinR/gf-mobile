import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/components/AnimatedDot.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/config/keys.dart';
import 'package:gf_mobile/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfOnboarded();
  }

  void checkIfOnboarded() async {
    await Future.delayed(const Duration(seconds: 3));
    final checkIsOnboarded = GetStorage().read(isOnboarded);

    if (checkIsOnboarded == null) {
      Get.toNamed(Routes.onboard);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo/bnbchain.svg',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            const TitleText(title: "BNB GreenField"),
            const SizedBox(height: 20),
            AnimatedDotsText(
              text: 'Initializing Experience',
              dotColor: Theme.of(context).textTheme.titleMedium!.color,
              dotRadius: 3.0,
              dotSpacing: 5.0,
              animationDuration: Duration(milliseconds: 500),
            )
          ],
        ),
      ),
    );
  }
}
