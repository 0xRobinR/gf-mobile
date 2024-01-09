import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/interfaces/gf_global.dart';

Future<String> updateObject(
    {required String bucketName,
    required String objectName,
    required String creator,
    required String authKey,
    required GfVisibilityType visibilityType}) async {
  final res = await GfSdk().updateObject(
      authKey: "0x$authKey",
      objectName: objectName,
      bucketName: bucketName,
      creator: creator,
      visibilityType: visibilityType);

  print(res);

  return res;
}
