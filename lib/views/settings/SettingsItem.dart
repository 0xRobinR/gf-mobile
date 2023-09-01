import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GListTile(
            index: 0,
            icon: null,
            title: "sync node",
            subtitle: "sync data from greenfield\n"
                "(background process)",
            trailingIcon: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blueAccent,
              inactiveThumbColor: Colors.grey,
            )),
        GListTile(
            index: 0,
            icon: null,
            title: "default storage provider",
            subtitle: "set/change default storage provider",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            )),
        GListTile(
            index: 0,
            icon: null,
            title: "update rpc",
            subtitle: "change rpc url",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            )),
        GListTile(
            index: 0,
            icon: null,
            title: "get tBNB",
            subtitle: "get testnet BNB from faucet",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            )),
        GListTile(
            index: 0,
            icon: null,
            title: "bridge tokens",
            subtitle: "bridge tokens from BSC to GF",
            trailingIcon: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
              onPressed: () {},
            ))
      ],
    );
  }
}
