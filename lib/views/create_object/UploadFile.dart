import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/routes.dart';

class UploadFile extends StatefulWidget {
  final String bucketName;

  const UploadFile({super.key, required this.bucketName});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.filesOverview,
            arguments: {"bucketName": widget.bucketName});
      },
      child: Column(
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(Icons.upload_file),
                    Text("Upload Files"),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
