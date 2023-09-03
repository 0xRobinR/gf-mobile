import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/state/FetchUserBuckets.dart';
import 'package:gf_mobile/views/my_files/components/GFFileTile.dart';
import 'package:gf_sdk/models/GFBucket.dart';

class GFFiles extends StatefulWidget {
  const GFFiles({super.key});

  @override
  State<GFFiles> createState() => _GFFilesState();
}

class _GFFilesState extends State<GFFiles> {
  List<GFBucket> buckets = [];

  @override
  void initState() {
    super.initState();
    fetchBuckets();
  }

  fetchBuckets() async {
    final fetchedBuckets = await getUserBuckets(
        address: "0xbb900Eacda882c7c2FA5C1e548D7E7149d31Ccee",
        spURL: "https://gnfd-testnet-sp1.bnbchain.org");

    setState(() {
      buckets = fetchedBuckets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Files"),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Subtitle(title: "Here are your buckets on Greenfield"),
              ...buckets
                  .map((e) => GFFileTile(
                      title: e.bucketName,
                      createdAt: e.created * 1000,
                      block: e.block))
                  .toList()
            ],
          ),
        ),
      )),
    );
  }
}
