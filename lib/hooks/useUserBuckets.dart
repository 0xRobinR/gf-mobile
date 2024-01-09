import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/BucketNotifier.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/models/GFBucket.dart';
import 'package:provider/provider.dart';

useUserBuckets(BuildContext context, spUrl) async {
  final address = Provider.of<AddressNotifier>(context, listen: false).address;
  try {
    if (address == "") {
      return;
    }
    final buckets =
        await GfSdk().getUserBuckets(address: address, spAddress: spUrl);
    final jsonBuckets = jsonDecode(buckets ?? "[]");
    List<GFBucket> gfBuckets = [];
    for (var bucket in jsonBuckets) {
      gfBuckets.add(GFBucket.fromJson(bucket));
    }
    print("buckets $gfBuckets");
    Provider.of<BucketNotifier>(context, listen: false).setBuckets(gfBuckets);
  } catch (e) {
    print("error while fetching buckets $e");
  }
}
