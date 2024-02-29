import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/services/encryptCall.dart';
import 'package:local_auth/local_auth.dart';

class AuthNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  final String _isLoggedInKey = 'isLoggedIn';
  String _previousPin = '';
  final String _pinKey = 'pin';
  String _pin = '';
  final String _bioKey = 'bio';
  BiometricType _biometricType = BiometricType.fingerprint;

  bool get isLoggedIn => _storage.read(_isLoggedInKey) ?? false;

  bool get isBioEnabled => _storage.read(_bioKey) ?? false;

  bool get isPinEnabled =>
      _storage.read(_pinKey) != null ? _storage.read(_pinKey) != "" : false;

  String get previousPin => _previousPin;

  get biometricType => _biometricType;

  void disableAuth() {
    _storage.write(_isLoggedInKey, false);
    _storage.write(_bioKey, false);
    _storage.remove(_pinKey);
    notifyListeners();
  }

  void disableBiometrics() {
    _storage.write(_bioKey, false);
    notifyListeners();
  }

  String get pin => _pin;

  void enableAuth(String pin) {
    String pinHash = generateMD5Hash(pin);
    _pin = pinHash;
    _storage.write(_pinKey, pinHash);
    _storage.write(_isLoggedInKey, true);
    notifyListeners();
  }

  bool verifyPin(String pin) {
    String pinHash = generateMD5Hash(pin);
    return pinHash == _pin;
  }

  void changeAuth(String newPin) {
    _previousPin = _pin;
    _storage.write("previousPin", _previousPin);
    enableAuth(newPin);
  }

  void enableBio() {
    _storage.write(_bioKey, true);
    notifyListeners();
  }

  void init() async {
    bool storedLoginState = _storage.read(_isLoggedInKey) ?? false;
    if (storedLoginState != isLoggedIn) {
      notifyListeners();
    }

    final availableBiometric =
        await LocalAuthentication().getAvailableBiometrics();
    if (availableBiometric.isNotEmpty) {
      _biometricType = availableBiometric.first;
      notifyListeners();
    }
  }
}
