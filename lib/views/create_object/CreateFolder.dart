import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/hooks/useFetchObjects.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/utils/showSnackbar.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/models/CreateObjectApproval.dart';
import 'package:provider/provider.dart';

class CreateFolder extends StatefulWidget {
  final String bucketName;

  const CreateFolder({super.key, required this.bucketName});

  @override
  State<CreateFolder> createState() => _CreateFoldertate();
}

class _CreateFoldertate extends State<CreateFolder> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading
          ? null
          : () async {
              //   alert folder name
              final folderName = await showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController _folderNameController =
                        TextEditingController();
                    return AlertDialog(
                      title: const Text("Create Folder"),
                      content: TextField(
                        controller: _folderNameController,
                        decoration: const InputDecoration(
                          hintText: "Folder Name",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(
                                result: {"created": false, "folderName": ""});
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(result: {
                              "created": true,
                              "folderName": _folderNameController.text
                            }, closeOverlays: false);
                          },
                          child: const Text("Create"),
                        ),
                      ],
                    );
                  });
              if (folderName['created']) {
                setState(() {
                  isLoading = true;
                });
                final wallet =
                    Provider.of<AddressNotifier>(context, listen: false);
                final res = await GfSdk().createFolder(
                    authKey: "0x${wallet.privateKey}",
                    opts: CreateObjectEstimate(
                        bucketName: widget.bucketName,
                        objectName: folderName['folderName'],
                        creator: wallet.address));
                print("create folder $res");
                final resJson = jsonDecode(res);
                setState(() {
                  isLoading = false;
                });
                if (resJson['error'] != null) {
                  showSnackbar(
                      title: 'Error',
                      message: resJson['error'],
                      color: Colors.red,
                      textColor: Colors.white);
                } else {
                  final objects =
                      await useFetchObjects(bucketName: widget.bucketName);
                  final bucketObjects =
                      Provider.of<ObjectNotifier>(context, listen: false)
                          .objects;
                  Provider.of<ObjectNotifier>(context, listen: false)
                      .setObjects({
                    widget.bucketName: {...bucketObjects, "objects": objects},
                  });
                  Get.back(result: {"created": true, "folderName": folderName});
                  showSnackbar(
                      title: 'Success',
                      message: 'Folder created successfully',
                      color: Colors.green,
                      textColor: Colors.white);
                }
              }
            },
      child: Column(
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? const GFLoader(
                        width: 40,
                        dotColor: Colors.white,
                      )
                    : const Column(
                        children: [
                          Icon(Icons.create_new_folder),
                          Text("Create Folder"),
                        ],
                      ),
              )),
        ],
      ),
    );
  }
}
