import 'package:flutter/material.dart';
import 'package:gf_mobile/components/GFDivider.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/views/settings/SettingsItem.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TitleText(title: "Settings"),
          centerTitle: true,
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {}
            )
          ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Column(
              children: [
                SizedBox(height: 10),
                SettingsItem(),
                GFDivider(),
                SettingsItem(),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
