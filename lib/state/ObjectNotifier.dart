import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class ObjectNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  Map<String, dynamic> _objects = {};

  Map<String, dynamic> get objects => _objects;

  saveToStorage() {
    _storage.write("user_objects", jsonEncode(_objects));
  }

  void setObjects(Map<String, dynamic> object) {
    _objects = {
      ..._objects,
      ...object,
    };

    saveToStorage();
    notifyListeners();
  }

  void loadFromStorage() {
    _objects = jsonDecode(_storage.read("user_objects") ?? "[]");
    notifyListeners();
  }
}
