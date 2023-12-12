import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/config/app.dart';
import 'package:gf_mobile/hooks/useAuthCall.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';
import 'package:local_auth/local_auth.dart';
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
      callThis(value) async {
        if (value) {
          initiatePinSetupProcess(context);
        } else {
          Map<String, bool> auth = await checkAuthentication(context);
          if (auth.isNotEmpty && auth["isAuthenticated"]!) {
            authNotifier.disableAuth();
          } else if (auth.isNotEmpty && !auth["isAuthenticated"]!) {
            Get.snackbar(
              "Authentication Error",
              "Invalid authentication detected. Please try again.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              icon: const Icon(Icons.lock, color: Colors.white),
              shouldIconPulse: true,
            );

            Get.back();
          }
        }
      }

      return GListTile(
        index: 0,
        icon: null,
        title: "add app authentication",
        subtitle: "set pin/biometric authentication",
        onTap: () {
          callThis(!authNotifier.isLoggedIn);
        },
        trailingIcon: Switch(
          value: authNotifier.isLoggedIn,
          onChanged: callThis,
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
      IconData getBiometricIcon() {
        switch (authNotifier.biometricType) {
          case BiometricType.face:
            return Icons.face;
          case BiometricType.fingerprint:
            return Icons.fingerprint;
          case BiometricType.iris:
            return Icons.remove_red_eye;
          default:
            return Icons.fingerprint;
        }
      }

      callThis(value) async {
        if (value) {
          authenticateWithBiometrics(
              context, "$appName wants to verify your identity");
        } else {
          Map<String, bool> auth = await checkAuthentication(context);
          if (auth.isNotEmpty && auth["isAuthenticated"]!) {
            authNotifier.disableBiometrics();
          }
        }
      }

      return GListTile(
        index: 0,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(getBiometricIcon()),
          ],
        ),
        title: "add biometric authentication",
        subtitle: "set biometrics",
        onTap: () {
          callThis(!authNotifier.isBioEnabled);
        },
        trailingIcon: Switch(
          value: authNotifier.isBioEnabled,
          onChanged: callThis,
          activeColor: Colors.blueAccent,
          inactiveThumbColor: Colors.grey,
        ),
      );
    });
  }
}
