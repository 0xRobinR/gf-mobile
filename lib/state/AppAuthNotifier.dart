import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AuthNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  final String _isLoggedInKey = 'isLoggedIn';
  final String _pinKey = 'pin';
  final String _pin = '';
  final String _bioKey = 'bio';

  bool get isLoggedIn => _storage.read(_isLoggedInKey) ?? false;

  bool get isBioEnabled => _storage.read(_bioKey) ?? false;

  bool get isPinEnabled =>
      _storage.read(_pinKey) != null ? _storage.read(_pinKey) != "" : false;

  void disableAuth() {
    _storage.write(_isLoggedInKey, false);
    _storage.write(_bioKey, false);
    _storage.remove(_pinKey);
    notifyListeners();
  }

  String get pin => _pin;

  void enableAuth(String pin) {
    _storage.write(_pinKey, pin);
    _storage.write(_isLoggedInKey, true);
    notifyListeners();
  }

  void enableBio() {
    _storage.write(_bioKey, true);
    notifyListeners();
  }

  void init() {
    bool storedLoginState = _storage.read(_isLoggedInKey) ?? false;
    if (storedLoginState != isLoggedIn) {
      notifyListeners();
    }
  }
}
