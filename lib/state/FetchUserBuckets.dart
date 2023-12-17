import "dart:convert";

import "package:gf_sdk/gf_sdk.dart";
import "package:gf_sdk/models/GFBucket.dart";

Future<List<GFBucket>> getUserBuckets(
    {required String address, required String spURL}) async {
  try {
    final buckets =
        await GfSdk().getUserBuckets(address: address, spAddress: spURL);

    final jsonBuckets = jsonDecode(buckets ?? "");
    List<GFBucket> gfBuckets = [];
    for (var bucket in jsonBuckets) {
      gfBuckets.add(GFBucket.fromJson(bucket));
    }

    return gfBuckets;
  } catch (e) {
    print("error fetching buckets $e");
    return [];
  }
}

Future<String> createBucket(
    {required String authKey,
    required String primaryAddress,
    required String bucketName,
    required String spAddress}) async {
  final bucket = await GfSdk().createBucket(
      authKey: authKey,
      primaryAddress: primaryAddress,
      spAddress: spAddress,
      bucketName: bucketName);
  return bucket ?? "";
}
