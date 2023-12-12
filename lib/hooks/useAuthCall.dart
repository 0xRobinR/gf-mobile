import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

Future<bool> authenticateWithBiometrics(
    BuildContext context, String reason) async {
  LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = await auth.canCheckBiometrics;
  final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();

  if (canCheckBiometrics) {
    try {
      bool isEnabled = await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      if (isEnabled) {
        setBioMetrics(context);
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  } else {
    return false;
  }
}

Future<Map<String, bool>> checkAuthentication(BuildContext context,
    {bool? isForcePin}) async {
  final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  bool isBioEnabled = authNotifier.isBioEnabled;
  bool isPinEnabled = authNotifier.isPinEnabled;

  bool isForcePin0 = isForcePin ?? false;

  if (isBioEnabled && !isForcePin0) {
    bool result = await authenticateWithBiometrics(
        context, 'Authenticate using Biometrics');
    Get.back();
    return {"isAuthenticated": result, "isAuthEnabled": true};
  } else if (isPinEnabled) {
    String? enteredPin =
        await promptUserForPin(context, 'Authenticate using Pin');
    if (enteredPin == null || enteredPin.isEmpty) {
      return {"isAuthenticated": false, "isAuthEnabled": true};
    }
    bool result = verifyPIN(enteredPin);
    return {"isAuthenticated": result, "isAuthEnabled": true};
  } else {
    return {"isAuthenticated": false, "isAuthEnabled": false};
  }
}

final GetStorage box = GetStorage();

void setPIN(BuildContext context, String pin) {
  Provider.of<AuthNotifier>(context, listen: false).enableAuth(pin);
}

void setBioMetrics(BuildContext context) {
  Provider.of<AuthNotifier>(context, listen: false).enableBio();
}

bool verifyPIN(String inputPin) {
  String storedPin = box.read('pin') ?? '';
  return storedPin == inputPin;
}

Future<String?> promptUserForPin(BuildContext context, String title) async {
  String? enteredPin;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: PinCodeFields(
          length: 4,
          fieldBorderStyle: FieldBorderStyle.square,
          responsive: true,
          fieldHeight: 50.0,
          fieldWidth: 40.0,
          borderWidth: 2.0,
          activeBorderColor: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
          keyboardType: TextInputType.number,
          autofocus: true,
          onComplete: (output) {
            enteredPin = output;
            Navigator.pop(context, enteredPin);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );

  return enteredPin;
}

Future<void> initiatePinSetupProcess(BuildContext context) async {
  String? newPin = await promptUserForPin(context, 'Enter New PIN');
  if (newPin == null || newPin.isEmpty) {
    return;
  }

  String? confirmPin = await promptUserForPin(context, 'Confirm Your PIN');
  if (confirmPin == null || confirmPin.isEmpty) {
    Get.snackbar(
      'Error',
      'PIN cannot be empty',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    return;
  }

  if (newPin == confirmPin) {
    setPIN(context, newPin);
    await authenticateWithBiometrics(
        context, 'Add Biometrics to Greenfield Mobile');
  } else {
    Get.snackbar(
      'Error',
      'PINs do not match',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    initiatePinSetupProcess(context);
  }
}
