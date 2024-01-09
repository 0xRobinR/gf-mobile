import 'package:gf_sdk/gf_sdk.dart';

Future<String> deleteObject(
    {required String bucketName,
    required String objectName,
    required String creator,
    required String authKey}) async {
  final res = await GfSdk().deleteObject(
      authKey: "0x$authKey",
      objectName: objectName,
      bucketName: bucketName,
      creator: creator);

  print(res);

  return res;
}

Future<String> cancelObject(
    {required String bucketName,
    required String objectName,
    required String creator,
    required String authKey}) async {
  final res = await GfSdk().cancelObject(
      authKey: "0x$authKey",
      objectName: objectName,
      bucketName: bucketName,
      creator: creator);

  print(res);

  return res;
}
