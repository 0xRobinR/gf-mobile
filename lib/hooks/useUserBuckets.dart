import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/BucketNotifier.dart';
import 'package:gf_sdk/gf_sdk.dart';
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
    Provider.of<BucketNotifier>(context, listen: false).setBuckets(jsonBuckets);
  } catch (e) {
    print("error while fetching buckets $e");
  }
}
