import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gf_mobile/components/CachedImage.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/utils/getFileSize.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class FileListDisplay extends StatefulWidget {
  final List<File> files;
  final Function(File file)? onRemove;

  const FileListDisplay({Key? key, required this.files, this.onRemove})
      : super(key: key);

  @override
  State<FileListDisplay> createState() => _FileListDisplayState();
}

class _FileListDisplayState extends State<FileListDisplay> {
  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return const Center(
        child: Text("No files selected"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.files.length,
      itemBuilder: (context, index) {
        final file = widget.files[index];
        final mimeType = lookupMimeType(file.path);

        return GListTile(
            key: ValueKey(file.path),
            icon: _buildLeadingWidget(file, mimeType),
            title: basename(file.path),
            trailingIcon: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.red),
              onPressed: () => widget.onRemove!(file),
            ),
            index: index,
            subtitle: "${mimeType ?? 'Unknown'}\nSize: ${getFileSize(file)}"
            // Additional List Tile properties
            );
      },
    );
  }

  Widget _buildLeadingWidget(File file, String? mimeType) {
    if (mimeType != null && mimeType.startsWith('image/')) {
      return CachedImage(imagePath: file.path);
    } else {
      String _extension = extension(file.path).toUpperCase();
      return CircleAvatar(
        // backgroundColor: Colors.grey[300],
        child: Text(
          _extension,
          style: TextStyle(fontSize: 10),
        ),
      );
    }
  }
}
