import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadFolder extends StatefulWidget {
  const UploadFolder({super.key});

  @override
  State<UploadFolder> createState() => _UploadFolderState();
}

class _UploadFolderState extends State<UploadFolder> {
  selectFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
