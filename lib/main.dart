import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/routes.dart';
import 'package:gf_mobile/theme/themes.dart';

void main() {
  runApp(const GFMobile());
}

class GFMobile extends StatelessWidget {
  const GFMobile({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mobile',
      theme: primaryThemeData,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}