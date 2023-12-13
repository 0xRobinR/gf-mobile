import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/state/SPNotifier.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:provider/provider.dart';

class StorageProviderList extends StatefulWidget {
  const StorageProviderList({super.key});

  @override
  State<StorageProviderList> createState() => _StorageProviderListState();
}

class _StorageProviderListState extends State<StorageProviderList>
    with AutomaticKeepAliveClientMixin {
  var storageProviders = [];
  bool isLoading = true;
  String errorText = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getStorageProviders();
  }

  getStorageProviders() {
    final spNotifier = Provider.of<SPNotifier>(context, listen: false);
    GfSdk().getStorageProviders().then((value) {
      List sps = [];
      sps.add(spNotifier.spInfo);

      final resp = jsonDecode(value ?? "[]");
      for (var sp in resp) {
        if (sp["operator_address"] != spNotifier.spAddress) {
          sps.add(sp);
        }
      }
      setState(() {
        storageProviders = sps;
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
        errorText = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Storage Providers")),
      body: errorText != ""
          ? const Center(
              child: Text("Error loading storage providers"),
            )
          : isLoading
              ? const Center(
                  child: GFLoader(
                    dotColor: Colors.white,
                  ),
                )
              : Consumer<SPNotifier>(builder: (context, spNotifier, child) {
                  return ListView.builder(
                    itemCount: storageProviders.length,
                    itemBuilder: (context, index) {
                      String address =
                          storageProviders[index]["operator_address"];
                      Map<String, dynamic> description =
                          (storageProviders[index]['description']);
                      String status = storageProviders[index]["status"];
                      IconData statusIcon = status == "STATUS_IN_SERVICE"
                          ? Icons.circle
                          : Icons.error;
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          ListTile(
                            tileColor: address == spNotifier.spAddress
                                ? Colors.green[900]
                                : Colors.transparent,
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  "https://robohash.org/${address.substring(0, 6)}?set=set4"),
                            ),
                            title: Text("${description['moniker']}"),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "SP Address - ${address.substring(0, 6)}...${address.substring(address.length - 6)}"),
                                  Text(
                                      "Total Deposited - ${(double.parse(storageProviders[index]["total_deposit"]) / 1e18).toStringAsFixed(2)} BNB"),
                                  Text(
                                      "Endpoint - ${storageProviders[index]["endpoint"]}"),
                                ]),
                            trailing: Icon(
                              statusIcon,
                              size: 12,
                              color: statusIcon == Icons.circle
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            onTap: () {
                              spNotifier.updateSP(
                                  address, storageProviders[index]);
                              // Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                }),
    );
  }
}
