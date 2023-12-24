import 'package:flutter/material.dart';
import 'package:gf_mobile/views/create_object/CreateFolder.dart';
import 'package:gf_mobile/views/create_object/UploadFile.dart';

class CreateObject extends StatelessWidget {
  final String bucketName;

  const CreateObject({super.key, required this.bucketName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Add Files to $bucketName",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CreateFolder(bucketName: bucketName),
              UploadFile(bucketName: bucketName),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pop("create");
              //   },
              //   child: Column(
              //     children: [
              //       Card(
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(15)),
              //           elevation: 10,
              //           child: const Padding(
              //             padding: EdgeInsets.all(8.0),
              //             child: Column(
              //               children: [
              //                 Icon(Icons.drive_folder_upload),
              //                 Text("Upload Folder"),
              //               ],
              //             ),
              //           )),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
