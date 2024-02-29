import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
            title: "licenses",
            subtitle: "all libraries license used in greenfield",
            onTap: () {
              showLicensePage(context: context);
            },
            trailingIcon: const IconButton(
              icon: Icon(
                Icons.local_police,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: null,
            )),
        GListTile(
            index: 0,
            icon: null,
            title: "reset app",
            subtitle: "reset app to default settings (unsafe)",
            onTap: () {
              GetStorage().erase();
              Get.reload();
            },
            trailingIcon: const IconButton(
              icon: Icon(
                Icons.lock_reset,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: null,
            )),
        Subtitle(title: "version 1.0.0"),
      ],
    );
  }
}
