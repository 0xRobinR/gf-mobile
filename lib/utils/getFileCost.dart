import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/utils/getFileHash.dart';
import 'package:gf_mobile/utils/getFileMeta.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/interfaces/gf_global.dart';
import 'package:gf_sdk/models/CreateObjectApproval.dart';
import 'package:provider/provider.dart';

Future<Map<String, dynamic>> getEstimate(
    {required File file,
    required BuildContext context,
    required String bucketName,
    GfVisibilityType? visibilityType}) async {
  try {
    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    final hash = await computeHashFromFile(file);
    final contentTypeOfFile = getFileType(file.path);

    String result = await GfSdk().createObjectEstimate(
        authKey: "0x${wallet.privateKey}",
        opts: CreateObjectEstimate(
            contentLength: hash['contentLength'],
            objectName: file.path.split('/').last,
            bucketName: bucketName,
            creator: wallet.address,
            fileType: contentTypeOfFile,
            expectedChecksums: hash['expectedChecksums'],
            visibility: visibilityType ?? GfVisibilityType.private));

    print(result);
    final resJson = jsonDecode(result);
    if (resJson['error'] != null) {
      print(resJson['error']);
      return {
        "gasFee": 0,
        "gasPrice": 0,
        "gasLimit": 0,
        "error": resJson['error']
      };
    }

    return {
      "gasFee": resJson['gasFee'],
      "gasPrice": resJson['gasPrice'],
      "gasLimit": resJson['gasLimit'],
      "error": null
    };
  } catch (e) {
    // Handle the exception
    print("Error occurred: ${e.toString()}");
    return {"gasFee": 0, "gasPrice": 0, "gasLimit": 0, "error": e.toString()};
  }
}
