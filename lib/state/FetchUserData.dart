import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gf_sdk/gf_sdk.dart';

final bnbPriceUrl =
    "https://api.binance.com/api/v3/ticker/price?symbol=BNBUSDT";

final spURL = "https://gnfd-testnet-sp1.bnbchain.org";

Future<Map<String, dynamic>> getUserData(wallet) async {
  final address = wallet?.address;
  var bnbBalance = 0.0;
  var bnbValue = 0.0;
  var bucketCount = 0;

  if (address != null && address == "") {
    return {
      'bnbBalance': 0,
      'bnbValue': 0,
      'bucketCount': 0,
    };
  }

  final userData = await GfSdk().getAccountBalance(address: address);
  final json = jsonDecode(userData!);
  bnbBalance = double.parse(json['amount'] ?? "0");

  final bnbPrice = await Dio().get(bnbPriceUrl);
  final bnbPriceJson = bnbPrice.data['price'];
  bnbValue = (bnbBalance / 1e18) * double.parse(bnbPriceJson);

  final bucket = await GfSdk().getUserBuckets(
      address: address, spAddress: "https://gnfd-testnet-sp1.bnbchain.org");
  print(bucket);

  return {
    'bnbBalance': (bnbBalance / 1e18),
    'bnbValue': bnbValue,
    'bucketCount': 0,
  };
}
