import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GListTile(
            index: 0,
            icon: null,
            title: "add account",
            subtitle: "create/import new account",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            )),
        GListTile(
            index: 0,
            icon: null,
            title: "remove account",
            subtitle: "remove current account (unsafe)",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            )),
      ],
    );
  }
}
