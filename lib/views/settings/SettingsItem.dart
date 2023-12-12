import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';
import 'package:gf_mobile/views/settings/AppAuth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class SettingsItem extends StatefulWidget {
  SettingsItem({super.key});

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  LocalAuthentication auth = LocalAuthentication();
  bool isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    checkBiometrics();
  }

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      isBiometricAvailable = canCheckBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(builder: (context, authNotifier, child) {
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
              )),
          const AppAuth(),
          if (isBiometricAvailable && authNotifier.isLoggedIn)
            const BiometricAuth(),
        ],
      );
    });
  }
}
