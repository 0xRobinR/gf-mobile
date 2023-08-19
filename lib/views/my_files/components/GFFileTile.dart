import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/theme/themes.dart';

class GFFileTile extends StatelessWidget {
  const GFFileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GListTile(
        index: 0,
        icon: Icon(Icons.folder, color: bnbColor),
        title: "bucket 1",
        subtitle: "created on 12/08/2023",
        trailingIcon: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {}));
  }
}
