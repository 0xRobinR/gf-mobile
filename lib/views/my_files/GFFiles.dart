import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/components/grid/GGridView.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {}
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Subtitle(title: "Here are your files on Greenfield"),
                  GGridView(itemCount: 10)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
