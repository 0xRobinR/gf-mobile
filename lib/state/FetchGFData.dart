import 'package:gf_sdk/gf_sdk.dart';

Future<String?> getGFStats() async {
  return await GfSdk().getStats();
}
