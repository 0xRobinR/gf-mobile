import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class AddressNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  String _data = "";
  String _pkey = "";

  String get address => _data;

  String get privateKey => _pkey;

  void updateAddress(String data, String pkey) {
    print("Updating address $data");
    _data = data;
    _pkey = pkey;
    notifyListeners();
  }

  void loadData() {
    _data = _storage.read('address') ?? "";
    _pkey = _storage.read('privateKey') ?? "";

    print("Loading address $_data from storage, private key $_pkey");

    notifyListeners(); // Notify listeners when data is loaded
  }
}
