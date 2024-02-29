import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/config/keys.dart';
import 'package:gf_mobile/services/encryptCall.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';

class AddressNotifier extends ChangeNotifier {
  final AuthNotifier? authNotifier;
  final GetStorage _storage = GetStorage();
  final secureStorage = FlutterSecureStorage();

  String _data = "";
  String _pkey = "";

  AddressNotifier(this.authNotifier) {
    authNotifier?.addListener(handleAuthNotifierListener);
  }

  handleAuthNotifierListener() {
    final auth = authNotifier!.previousPin;
    final newPin = authNotifier!.pin;
    String encryptedPrivateKey = decrypt(privateKey, auth);
    String newEncryptedPrivateKey = encrypt(encryptedPrivateKey, newPin);
    secureStorage.write(key: "privateKey", value: newEncryptedPrivateKey);
  }

  @override
  void dispose() {
    authNotifier?.removeListener(handleAuthNotifierListener);
    super.dispose();
  }

  List<Map<String, String>> wallets = [];

  String get address => _data;

  String get privateKey => _pkey;

  String getAuthKey({required String pin}) {
    return decrypt(_pkey, pin);
  }

  saveToStorage() {
    _storage.write("wallet_list", jsonEncode(wallets));
    _storage.write("address", _data);
    _storage.write("privateKey", _pkey);
    _storage.write(isOnboarded, true);
  }

  void selectAddress(String data, String pkey) {
    bool isExistAddress = wallets.any((wallet) => wallet['address'] == data);
    if (isExistAddress) {
      _data = data;
      _pkey = pkey;

      saveToStorage();
    }
    notifyListeners();
  }

  void updateAddress(String data, String pkey) {
    bool isExistAddress = wallets.any((wallet) => wallet['address'] == data);
    final auth = authNotifier!.pin;
    if (!isExistAddress) {
      pkey = encrypt(pkey, auth);

      wallets.add({'address': data, 'privateKey': pkey});
      _data = data;
      _pkey = pkey;

      saveToStorage();
    }
    notifyListeners();
  }

  void removeAddress() {
    wallets.removeLast();

    if (wallets.isEmpty) {
      _data = "";
      _pkey = "";
      _storage.erase();
    } else {
      _data = wallets.last['address'] ?? "";
      _pkey = wallets.last['privateKey'] ?? "";
    }

    saveToStorage();
    notifyListeners();
  }

  void loadData() {
    _data = _storage.read('address') ?? "";
    _pkey = _storage.read('privateKey') ?? "";
    List<dynamic> decodedList =
        jsonDecode(_storage.read("wallet_list") ?? "[]");
    wallets =
        decodedList.map((item) => Map<String, String>.from(item)).toList();

    notifyListeners(); // Notify listeners when data is loaded
  }
}
