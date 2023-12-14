import 'dart:convert';

import 'package:gf_sdk/gf_sdk.dart';

Future<List<dynamic>> useFetchObjects(
    {required String bucketName,
    String? pageKey,
    List<dynamic>? objectCollected}) async {
  final bucket = bucketName;
  final _objectCount = await GfSdk().getBucketObjects(bucketName: bucket);

  final objectsInJson = jsonDecode(_objectCount ?? "[]");
  final isLastPage = objectsInJson['pagination']['next_key'] == null;
  final nextPageKey = objectsInJson['pagination']['next_key'];

  objectCollected = objectsInJson['object_infos'];

  if (isLastPage) {
    return objectCollected ?? [];
  }

  return useFetchObjects(
      bucketName: bucket,
      pageKey: nextPageKey,
      objectCollected: [...?objectCollected, ...objectsInJson['objects']]);
}
