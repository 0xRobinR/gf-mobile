import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class AddressNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  String _data = "";
  String _pkey = "";

  List<Map<String, String>> wallets = [];

  String get address => _data;

  String get privateKey => _pkey;

  saveToStorage() {
    _storage.write("wallet_list", jsonEncode(wallets));
    _storage.write("address", _data);
    _storage.write("privateKey", _pkey);
  }

  void updateAddress(String data, String pkey) {
    bool isExistAddress = wallets.any((wallet) => wallet['address'] == data);
    if (!isExistAddress) {
      // If the address does not exist in the wallets list, add it
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
