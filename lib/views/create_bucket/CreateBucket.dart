import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:provider/provider.dart';

class CreateBucket extends StatefulWidget {
  const CreateBucket({super.key});

  @override
  State<CreateBucket> createState() => _CreateBucketState();
}

class _CreateBucketState extends State<CreateBucket> {
  String bucketName = "";
  String estimatedGasFee = "";
  String authKey = "";
  String primaryAddress = "";

  bool isLoading = false;

  final bucketNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWallet();
  }

  fetchWallet() {
    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    setState(() {
      authKey = wallet.privateKey;
      primaryAddress = wallet.address;
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
        spAddress: "0x89A1CC91B642DECbC4789474694C606E0E0c420b",
        bucketName: bucketName);

    print(approval);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Create Bucket"), centerTitle: true, actions: []),
      body: SafeArea(
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
              ),
              style: TextStyle(
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
                        Text("Storage Provider"),
                        Spacer(),
                        Text("0x89A1C...c420b"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Gas Fee"),
                        Spacer(),
                        isLoading ? GFLoader() : Text("0.0 BNB"),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Available Balance"),
                        Spacer(),
                        Text("0.0 BNB"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Create Bucket"),
            )
          ],
        ),
      ),
    );
  }
}
