import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/theme/themes.dart';

class GFFileTile extends StatelessWidget {
  final String title;
  final int createdAt;
  final int block;

  const GFFileTile(
      {super.key,
      required this.title,
      required this.createdAt,
      required this.block});

  @override
  Widget build(BuildContext context) {
    // format date in dd-MMM-YY h:m a format
    return GListTile(
        index: 0,
        icon: Icon(Icons.folder, color: bnbColor),
        title: title,
        subtitle:
            "created on ${formatDate(DateTime.fromMillisecondsSinceEpoch(createdAt), [
              d,
              ' ',
              M,
              ' '
            ])} at block #$block",
        trailingIcon: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {}));
  }
}
