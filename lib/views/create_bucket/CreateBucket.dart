import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/FetchUserBuckets.dart';
import 'package:gf_mobile/state/FetchUserData.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:provider/provider.dart';

class CreateBucket extends StatefulWidget {
  const CreateBucket({super.key});

  @override
  State<CreateBucket> createState() => _CreateBucketState();
}

class _CreateBucketState extends State<CreateBucket> {
  String bucketName = "";
  String estimatedGasFee = "0";
  String gasPrice = "";
  String authKey = "";
  String primaryAddress = "";
  String spAddress = "";
  double balance = 0.0;
  late String errorText;

  bool isLoading = false;

  final bucketNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWallet();
    errorText = "";
  }

  fetchWallet() async {
    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    setState(() {
      authKey = "0x${wallet.privateKey}";
      primaryAddress = wallet.address;
      spAddress = "0x89A1CC91B642DECbC4789474694C606E0E0c420b";
    });

    final userData = await getUserData();
    setState(() {
      balance = userData['bnbBalance'];
    });
  }

  fetchEstimation() async {
    print("Fetching estimation");
    setState(() {
      isLoading = true;
    });
    if (bucketName.isEmpty) {
      return;
    }

    if (authKey.isEmpty) {
      return;
    }

    if (primaryAddress.isEmpty) {
      return;
    }

    final approval = await GfSdk().getApproval(
        authKey: authKey,
        primaryAddress: primaryAddress,
        spAddress: spAddress,
        bucketName: bucketName);

    final approvalInJson = jsonDecode(approval!);
    final error = approvalInJson['error'];
    if (error != null) {
      setState(() {
        isLoading = false;
        errorText = error['message'];
      });
      return;
    }

    setState(() {
      estimatedGasFee = approvalInJson['gasFee'];
      isLoading = false;
      gasPrice = (double.parse(approvalInJson['gasPrice']) / 1e18).toString();
      errorText = "";
    });
  }

  createCall() async {
    final createdBucket = await createBucket(
      authKey: authKey,
      primaryAddress: primaryAddress,
      bucketName: bucketName,
      spAddress: spAddress,
    );

    print(createdBucket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Create Bucket"), centerTitle: true, actions: []),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Buckets are containers for data stored on BNB Greenfield. Bucket name must be globally unique.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bucketNameController,
                onChanged: (String value) {
                  setState(() {
                    bucketName = value;
                  });
                  fetchEstimation();
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bucket Name',
                    errorText: errorText != "" ? errorText : null,
                    errorMaxLines: 2),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Storage Provider"),
                          const Spacer(),
                          Text(
                              "${spAddress.substring(0, 6)}...${spAddress.substring(spAddress.length - 4, spAddress.length)}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Gas Fee"),
                          const Spacer(),
                          isLoading
                              ? const GFLoader()
                              : Text("$estimatedGasFee BNB"),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Available Balance"),
                          const Spacer(),
                          Text("${balance.toString()} BNB"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  createCall();
                },
                child: const Text("Create Bucket"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
