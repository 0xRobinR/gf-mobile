import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';

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
      body: const Center(
        child: TitleText(title: "Settings"),
      )
    );
  }
}
