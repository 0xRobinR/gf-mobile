import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/config/app.dart';
import 'package:gf_mobile/hooks/useAuthCall.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';
import 'package:provider/provider.dart';

class AppAuth extends StatefulWidget {
  const AppAuth({super.key});

  @override
  State<AppAuth> createState() => _AppAuthState();
}

class _AppAuthState extends State<AppAuth> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(builder: (context, authNotifier, child) {
      return GListTile(
        index: 0,
        icon: null,
        title: "add app authentication",
        subtitle: "set pin/biometric authentication",
        trailingIcon: Switch(
          value: authNotifier.isLoggedIn,
          onChanged: (value) async {
            if (value) {
              initiatePinSetupProcess(context);
            } else {
              Map<String, bool> auth = await checkAuthentication(context);
              if (auth.isNotEmpty && auth["isAuthenticated"]!) {
                authNotifier.disableAuth();
              }
            }
          },
          activeColor: Colors.blueAccent,
          inactiveThumbColor: Colors.grey,
        ),
      );
    });
  }
}

class BiometricAuth extends StatefulWidget {
  const BiometricAuth({super.key});

  @override
  State<BiometricAuth> createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(builder: (context, authNotifier, child) {
      return GListTile(
        index: 0,
        icon: null,
        title: "add biometric authentication",
        subtitle: "set biometrics",
        trailingIcon: Switch(
          value: authNotifier.isBioEnabled,
          onChanged: (value) async {
            if (value) {
              authenticateWithBiometrics(
                  context, "$appName wants to verify your identity");
            } else {
              Map<String, bool> auth = await checkAuthentication(context);
              if (auth.isNotEmpty && auth["isAuthenticated"]!) {
                authNotifier.disableAuth();
              }
            }
          },
          activeColor: Colors.blueAccent,
          inactiveThumbColor: Colors.grey,
        ),
      );
    });
  }
}
