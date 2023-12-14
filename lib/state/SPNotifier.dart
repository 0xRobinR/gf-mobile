import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class SPNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();

  String _spAddress = "";
  Map<String, dynamic> _spInfo = {};

  String get spAddress => _spAddress;

  Map<String, dynamic> get spInfo => _spInfo;

  saveToStorage() {
    _storage.write("sp_address", _spAddress);
    _storage.write("sp_info", jsonEncode(_spInfo));
  }

  void updateSP(String spAddress, Map<String, dynamic> spInfo) {
    _spAddress = spAddress;
    _spInfo = spInfo;

    saveToStorage();
    notifyListeners();
  }

  void loadFromStorage() {
    _spAddress = _storage.read("sp_address") ?? "";
    _spInfo = jsonDecode(_storage.read("sp_info") ?? "{}");

    notifyListeners();
  }
}
