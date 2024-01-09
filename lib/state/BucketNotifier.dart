import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_sdk/models/GFBucket.dart';

class BucketNotifier extends ChangeNotifier {
  final GetStorage _storage = GetStorage();
  List<GFBucket> _buckets = [];

  List<GFBucket> get buckets => _buckets;

  saveToStorage() {
    _storage.write("user_buckets", jsonEncode(_buckets));
  }

  void setBuckets(List<GFBucket> bucket) {
    _buckets = bucket;

    saveToStorage();
    notifyListeners();
  }

  void loadFromStorage() {
    _buckets = jsonDecode(_storage.read("user_buckets") ?? "[]");
    notifyListeners();
  }
}
