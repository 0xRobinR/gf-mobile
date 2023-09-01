import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/theme/themes.dart';

class GFFileTile extends StatelessWidget {
  final String title;

  const GFFileTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GListTile(
        index: 0,
        icon: Icon(Icons.folder, color: bnbColor),
        title: title,
        subtitle: "created on 12/08/2023",
        trailingIcon: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {}));
  }
}
