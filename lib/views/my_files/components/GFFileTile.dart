import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';

class GFFileTile extends StatelessWidget {
  const GFFileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GListTile(
      index: 0,
      icon: const Icon(Icons.folder, color: Colors.blueAccent),
      title: "bucket 1",
      subtitle: "created on 12/08/2023",
      trailingIcon: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.grey),
        onPressed: () {}
      )
    );
  }
}
