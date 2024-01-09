import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/hooks/useFetchObjects.dart';
import 'package:gf_mobile/services/object/deleteObject.dart';
import 'package:gf_mobile/services/object/updateObject.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/utils/showSnackbar.dart';
import 'package:gf_sdk/interfaces/gf_global.dart';
import 'package:provider/provider.dart';

class GFFileObject extends StatefulWidget {
  final String bucketName;
  final Map<String, dynamic> object;
  final int index;

  const GFFileObject(
      {super.key,
      required this.bucketName,
      required this.object,
      required this.index});

  @override
  State<GFFileObject> createState() => _GFFileObjectState();
}

class _GFFileObjectState extends State<GFFileObject> {
  bool isDeleting = false;

  bool isUpdating = false;

  _deleteObject(String objectName, String status) async {
    setState(() {
      isDeleting = true;
    });

    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    String res = "{}";
    if (status == "OBJECT_STATUS_SEALED") {
      res = await deleteObject(
          bucketName: widget.bucketName,
          objectName: objectName,
          creator: wallet.address,
          authKey: wallet.privateKey);
    }
    if (status == "OBJECT_STATUS_CREATED") {
      res = await cancelObject(
          bucketName: widget.bucketName,
          objectName: objectName,
          creator: wallet.address,
          authKey: wallet.privateKey);
    }

    setState(() {
      isDeleting = false;
    });

    final resJson = jsonDecode(res);

    if (resJson['error'] != null) {
      showSnackbar(
        title: "Error",
        message: resJson['error']['message'],
      );
    }

    if (resJson['error'] == null) {
      final objects = await useFetchObjects(bucketName: widget.bucketName);
      final objectNotifier =
          Provider.of<ObjectNotifier>(context, listen: false);
      Provider.of<ObjectNotifier>(context, listen: false).setObjects({
        widget.bucketName: {
          ...objectNotifier.objects[widget.bucketName],
          "objects": objects,
        },
      });

      showSnackbar(
        title: "Success",
        message: "$objectName deleted successfully",
      );
    }
  }

  _updateObject(String objectName, GfVisibilityType visibilityType) async {
    setState(() {
      isUpdating = true;
    });

    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    String res = await updateObject(
        bucketName: widget.bucketName,
        objectName: objectName,
        creator: wallet.address,
        authKey: wallet.privateKey,
        visibilityType: visibilityType);

    setState(() {
      isUpdating = false;
    });

    final resJson = jsonDecode(res);

    if (resJson['error'] != null) {
      showSnackbar(
        title: "Error",
        message: resJson['error']['message'],
      );
    }

    if (resJson['error'] == null) {
      final objects = await useFetchObjects(bucketName: widget.bucketName);
      final objectNotifier =
          Provider.of<ObjectNotifier>(context, listen: false);
      Provider.of<ObjectNotifier>(context, listen: false).setObjects({
        widget.bucketName: {
          ...objectNotifier.objects[widget.bucketName],
          "objects": objects,
        },
      });

      showSnackbar(
        title: "Success",
        message:
            "$objectName set to ${visibilityType == GfVisibilityType.public ? "Public" : "Private"}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final object = widget.object;
    final visibility = object['visibility'] == "VISIBILITY_TYPE_PRIVATE"
        ? "Private"
        : "Public";

    // print("objects ${object['visibility']}");
    final status = object['object_status'];

    print("object $status");

    var smallObjectName = object['object_name'].length > 20
        ? object['object_name'].substring(0, 8) +
            "..." +
            object['object_name'].substring(
                object['object_name'].length - 8, object['object_name'].length)
        : object['object_name'];
    final isFolder = object['object_name'].endsWith("/");
    if (isFolder) {
      smallObjectName =
          smallObjectName.substring(0, smallObjectName.length - 1);
    }

    return GListTile(
      index: widget.index,
      title: smallObjectName,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isFolder ? const Icon(Icons.folder) : const Icon(Icons.file_present),
        ],
      ),
      subtitle: isFolder
          ? formatDate(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(object['create_at'].toString()) * 1000),
              [d, ' ', M, ' ', hh, ':', nn, ' ', am])
          : "${(double.parse(object['payload_size']) / 1024).toStringAsFixed(2)} KB\n$visibility"
              "\n${formatDate(DateTime.fromMillisecondsSinceEpoch(int.parse(object['create_at'].toString()) * 1000), [
                  d,
                  ' ',
                  M,
                  ' ',
                  hh,
                  ':',
                  nn,
                  ' ',
                  am
                ])}",
      trailingIcon: (isDeleting || isUpdating)
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFLoader(
                  dotColor: Colors.white,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isFolder
                  ? [
                      const IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: null,
                      ),
                    ]
                  : [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (status == "OBJECT_STATUS_SEALED")
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {},
                            ),
                          if (status == "OBJECT_STATUS_SEALED")
                            IconButton(
                              icon: Icon(visibility == "Private"
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                _updateObject(
                                    object['object_name'],
                                    visibility == "Private"
                                        ? GfVisibilityType.public
                                        : GfVisibilityType.private);
                              },
                            ),
                          IconButton(
                              onPressed: () {
                                _deleteObject(object['object_name'], status);
                              },
                              icon: status == "OBJECT_STATUS_CREATED"
                                  ? const Icon(Icons.cancel_outlined)
                                  : const Icon(Icons.delete)),
                        ],
                      ),
                    ],
            ),
      onTap: () {
        if (isFolder) {
          return;
        }
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 200,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text("Download"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(visibility == "Private"
                      ? Icons.visibility_off
                      : Icons.visibility),
                  title: Text(
                      "${visibility == "Private" ? "Make public" : "Make private"}"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _updateObject(
                        object['object_name'],
                        visibility == "Private"
                            ? GfVisibilityType.public
                            : GfVisibilityType.private);
                  },
                ),
                ListTile(
                  leading: (status == "OBJECT_STATUS_SEALED")
                      ? const Icon(Icons.delete)
                      : const Icon(Icons.cancel_outlined),
                  title: (status == "OBJECT_STATUS_SEALED")
                      ? const Text("Delete")
                      : const Text("Cancel Upload"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _deleteObject(object['object_name'], status);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
