import 'package:dio/dio.dart';
import 'package:gf_mobile/config/urls.dart';

Future<String> getBucketsCreated() async {
  try {
    final dio = await Dio().get(bucketCountFetch());
    final res = dio.data['result'];
    return res.toString();
  } catch (e) {
    print(e);
    return "0";
  }
}

Future<String> getObjectCount() async {
  try {
    final dio = await Dio().get(objectFetchCount());
    final res = dio.data['result'];
    return res.toString();
  } catch (e) {
    print(e);
    return "0";
  }
}

Future<String> getTransactionCount() async {
  try {
    final dio = await Dio().get(totalTransactionsCount());
    final res = dio.data['result'];
    return res.toString();
  } catch (e) {
    print(e);
    return "0";
  }
}
