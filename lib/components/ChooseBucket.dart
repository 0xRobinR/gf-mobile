import 'package:flutter/material.dart';
import 'package:gf_mobile/views/my_files/GFFiles.dart';

class ChooseBucket extends StatefulWidget {
  const ChooseBucket({super.key});

  @override
  State<ChooseBucket> createState() => _ChooseBucketState();
}

class _ChooseBucketState extends State<ChooseBucket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Bucket"),
      ),
      body: GFFiles(
        showForSelect: true,
      ),
    );
  }
}
