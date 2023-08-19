import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/views/my_files/components/GFFileTile.dart';

class GFFiles extends StatefulWidget {
  const GFFiles({super.key});

  @override
  State<GFFiles> createState() => _GFFilesState();
}

class _GFFilesState extends State<GFFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Files"),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Subtitle(title: "Here are your buckets on Greenfield"),
                GFFileTile(),
                GFFileTile(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
