import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gf_mobile/config/app.dart';

String gfScan(address) {
  return "https://testnet.greenfieldscan.com/account/$address";
}

const String bridgeUrl = "https://dcellar.io/wallet?type=transfer_in";

String bucketCountFetch() {
  String? key = dotenv.env['NODE_REAL_API_KEY'];
  return "https://open-platform.nodereal.io/$key/greenfieldscan-$network/greenfield/storage/bucket/count";
}

String objectFetchCount() {
  String? key = dotenv.env['NODE_REAL_API_KEY'];
  return "https://open-platform.nodereal.io/$key/greenfieldscan-$network/greenfield/storage/object/count";
}

String totalTransactionsCount() {
  String? key = dotenv.env['NODE_REAL_API_KEY'];
  return "https://open-platform.nodereal.io/$key/greenfieldscan-$network/greenfield/tx/count?time_slot=from_genesis";
}
