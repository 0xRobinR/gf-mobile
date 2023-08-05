import 'package:gf_mobile/config/network.dart';

genDynamicBalance({required String address}) {
  return "$gRPC/greenfield/payment/dynamic_balance/$address";
}

genGetSPproviders() {
  return "$gRPC/greenfield/storage_providers";
}

genGetSPpriceRealTime({required String opAddress}) {
  return "$gRPC/greenfield/sp/get_sp_storage_price_by_time/$opAddress/0";
}

genGetBucketInfo({String? bucketName, int? bucketID}) {
  if (bucketName != null) {
    return "$gRPC/greenfield/storage/head_bucket/$bucketName";
  } else if (bucketID != null) {
    return "$gRPC/greenfield/storage/head_bucket_by_id/$bucketID";
  } else {
    throw Exception("Bucket name or ID must be provided");
  }
}

genGetObjectInfo({required String bucketName, String? objectName, int? objectID}) {
  if (objectName != null) {
    return "$gRPC/greenfield/storage/head_object/$bucketName/$objectName";
  } else if (objectID != null) {
    return "$gRPC/greenfield/storage/head_object_by_id/$objectID";
  } else {
    throw Exception("Object name or ID must be provided");
  }
}

genGetObjectsInBucket({required String bucketName}) {
  return "$gRPC/greenfield/storage/list_objects/$bucketName";
}

genGetListBuckets({String? paginationKey}) {
  if (paginationKey != null) {
    return "$gRPC/greenfield/storage/list_buckets?pagination.key=$paginationKey&pagination.limit=10";
  } else {
    return "$gRPC/greenfield/storage/list_buckets?pagination.limit=10";
  }
}

genGetStorageParams() {
  return "$gRPC/greenfield/storage/params";
}

genGetDetailInfo({required String address}) {
  return "$gRPC/cosmos/auth/v1beta1/account_info/$address";
}

genGetAccountBalances({required String address}) {
  return "$gRPC/cosmos/bank/v1beta1/balances/$address";
}

genGetLatestBlock() {
  return "$gRPC/cosmos/base/tendermint/v1beta1/blocks/latest";
}