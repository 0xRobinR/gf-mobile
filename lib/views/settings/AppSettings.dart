import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/components/list/GListTile.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GListTile(
            index: 0,
            icon: null,
            title: "reset app",
            subtitle: "reset app to default settings (unsafe)",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.lock_reset,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            )),
        Subtitle(title: "version 1.0.0"),
      ],
    );
  }
}
