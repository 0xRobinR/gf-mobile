import "dart:convert";

import "package:gf_sdk/gf_sdk.dart";
import "package:gf_sdk/models/GFBucket.dart";

Future<List<GFBucket>> getUserBuckets(
    {required String address, required String spURL}) async {
  final buckets =
      await GfSdk().getUserBuckets(address: address, spAddress: spURL);

  final jsonBuckets = jsonDecode(buckets ?? "");
  List<GFBucket> gfBuckets = [];
  for (var bucket in jsonBuckets) {
    gfBuckets.add(GFBucket.fromJson(bucket));
  }

  return gfBuckets;
}
