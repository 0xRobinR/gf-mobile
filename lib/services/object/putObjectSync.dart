import 'dart:io';

import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/interfaces/gf_global.dart';
import 'package:gf_sdk/models/CreateObjectApproval.dart';
import 'package:workmanager/workmanager.dart';

putObjectSync(
    {required File file,
    required String bucketName,
    required String objectName,
    required String txHash,
    required String authKey}) async {
  final filePath = file.path;

  final res = await GfSdk().uploadObject(
      authKey: authKey,
      opts: CreateObjectEstimate(
        contentLength: file.lengthSync(),
        expectedChecksums: [],
        fileType: "FILE_TYPE_FILE",
        objectName: objectName,
        bucketName: bucketName,
        creator: "",
        visibility: GfVisibilityType.public,
      ),
      filePath: filePath,
      txHash: txHash);

  print(res);

  return res;
}

startBackgroundUpload() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task: $task");
    putObjectSync(
        file: File(inputData?["filePath"]),
        bucketName: inputData?["bucketName"],
        objectName: inputData?["objectName"],
        txHash: inputData?["txHash"],
        authKey: inputData?["authKey"]);
    return Future.value(true);
  });
}

Future<void> scheduleBackgroundUpload(
    {required String filePath,
    required String bucketName,
    required String objectName,
    required String txHash,
    required String authKey}) async {
  final inputData = {
    "filePath": filePath,
    "bucketName": bucketName,
    "objectName": objectName,
    "txHash": txHash,
    "authKey": authKey
  };
  await Workmanager().registerOneOffTask(
    "upload-$objectName",
    "uploadObjectTask",
    inputData: inputData,
  );
}
