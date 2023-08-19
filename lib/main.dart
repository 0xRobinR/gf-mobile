import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/routes.dart';
import 'package:gf_mobile/theme/theme_controller.dart';
import 'package:gf_mobile/theme/themes.dart';

void main() async {
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(GFMobile());
}

class GFMobile extends StatelessWidget {
  ThemeController themeController = Get.find();

  GFMobile({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isPlatformDark = themeController.isDarkMode.value;
    final initTheme = isPlatformDark ? primaryThemeData : lightModeThemeData;

    return ThemeProvider(
        initTheme: initTheme,
        builder: (context, themeData) {
          return GetMaterialApp(
            title: 'Greenfield',
            theme: themeData,
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            darkTheme: primaryThemeData,
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
