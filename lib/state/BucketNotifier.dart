import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class BucketNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  List<dynamic> _buckets = [];

  List<dynamic> get buckets => _buckets;

  saveToStorage() {
    _storage.write("user_buckets", jsonEncode(_buckets));
  }

  void setBuckets(List<dynamic> bucket) {
    _buckets = bucket;

    saveToStorage();
    notifyListeners();
  }

  void loadFromStorage() {
    _buckets = jsonDecode(_storage.read("user_buckets") ?? "[]");
    notifyListeners();
  }
}
