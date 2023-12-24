import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gf_sdk/gf_sdk.dart';

Future<Map<String, dynamic>> computeHashFromFile(File file) async {
  try {
    Uint8List fileBytes = await file.readAsBytes();
    String result = await GfSdk().computeHash(buffer: fileBytes);
    final resAsJson = jsonDecode(result);
    // print(resAsJson);
    return {
      "contentLength": resAsJson['contentLength'],
      "expectedChecksums": jsonDecode(resAsJson['expectCheckSums']),
      "redundancyVal": resAsJson['redundancyVal'],
    };
  } on PlatformException catch (e) {
    // Handle the exception
    print("Error occurred: ${e.message}");
    return {
      "contentLength": 0,
      "expectedChecksums": [],
      "redundancyVal": 0,
    };
  }
}
