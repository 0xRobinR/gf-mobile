import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/FetchUserBuckets.dart';
import 'package:gf_mobile/state/SPNotifier.dart';
import 'package:gf_mobile/views/my_files/components/GFBucketTile.dart';
import 'package:gf_sdk/models/GFBucket.dart';
import 'package:provider/provider.dart';

class GFFiles extends StatefulWidget {
  const GFFiles({super.key});

  @override
  State<GFFiles> createState() => _GFFilesState();
}

class _GFFilesState extends State<GFFiles> {
  List<GFBucket> buckets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchBuckets();
    });

    final spNotifier = Provider.of<SPNotifier>(context, listen: false);
    spNotifier.addListener(fetchBuckets);

    final addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    addressNotifier.addListener(fetchBuckets);
  }

  fetchBuckets() async {
    final address =
        Provider.of<AddressNotifier>(context, listen: false).address;
    final spNotifier = Provider.of<SPNotifier>(context, listen: false).spInfo;

    if (!mounted) {
      return;
    }

    if (address == "") {
      setState(() {
        isLoading = false;
        buckets = [];
      });
      return;
    }
    final fetchedBuckets =
        await getUserBuckets(address: address, spURL: spNotifier['endpoint']);

    print("fetched buckets $fetchedBuckets");

    setState(() {
      buckets = fetchedBuckets;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Subtitle(title: "Here are your buckets on Greenfield"),
                ],
              ),
              ...buckets
                  .map((e) => GFBucketTile(
                      title: e.bucketName,
                      createdAt: e.created * 1000,
                      block: e.block))
                  .toList(),
              if (isLoading) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GFLoader(
                      dotColor: Theme.of(context).textTheme.bodyMedium?.color,
                      width: 50,
                    )
                  ],
                ),
              ],
              if (buckets.isEmpty && !isLoading) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Subtitle(
                        title:
                            "You don't have any buckets in the selected SP yet!"),
                  ],
                ),
              ]
            ],
          ),
        ),
      )),
    );
  }
}
