import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/GFDivider.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/theme/theme_controller.dart';
import 'package:gf_mobile/views/settings/AccountSettings.dart';
import 'package:gf_mobile/views/settings/AppSettings.dart';
import 'package:gf_mobile/views/settings/SettingsItem.dart';

import '../../theme/themes.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeController themeController = Get.find();
  bool isDarkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  getTheme() async {
    isDarkMode = themeController.isDarkMode.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(title: "Settings"),
        centerTitle: true,
        elevation: 0,
        actions: [
          ThemeSwitcher.withTheme(builder: (context, switcher, theme) {
            return IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () async {
                  switcher.changeTheme(
                      theme: theme.brightness == Brightness.dark
                          ? lightModeThemeData
                          : primaryThemeData);

                  Get.find<ThemeController>().toggleTheme();
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                });
          })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Column(children: [
              SizedBox(height: 10),
              SettingsItem(),
              GFDivider(),
              AccountSettings(),
              GFDivider(),
              AppSettings()
            ]),
          ),
        ),
      ),
    );
  }
}
