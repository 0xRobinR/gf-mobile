import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gf_mobile/components/CachedImage.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/utils/getFileSize.dart';
import 'package:gf_sdk/interfaces/gf_global.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class FileListDisplay extends StatefulWidget {
  final List<File> files;
  final Function(File file)? onRemove;
  final Function(File file, GfVisibilityType type)? onVisibilityChange;
  final List<GfVisibilityType> visibilities;
  final List<bool> isUploading;
  final List<bool> isUploaded;

  const FileListDisplay(
      {Key? key,
      required this.files,
      this.onRemove,
      this.onVisibilityChange,
      required this.visibilities,
      required this.isUploading,
      required this.isUploaded})
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.files.length,
      itemBuilder: (context, index) {
        final file = widget.files[index];
        final mimeType = lookupMimeType(file.path);

        return GListTile(
            key: ValueKey(file.path),
            icon: _buildLeadingWidget(file, mimeType),
            title: basename(file.path),
            trailingIcon: widget.isUploading[widget.files.indexOf(file)]
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!widget.isUploaded[widget.files.indexOf(file)])
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.green),
                        ),
                      if (widget.isUploaded[widget.files.indexOf(file)])
                        const Icon(Icons.check_rounded, color: Colors.green),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<GfVisibilityType>(
                            value: widget.visibilities[index],
                            onChanged: (GfVisibilityType? newValue) {
                              if (newValue != null) {
                                widget.onVisibilityChange!(file, newValue);
                              }
                            },
                            items: GfVisibilityType.values
                                .map<DropdownMenuItem<GfVisibilityType>>(
                                    (GfVisibilityType value) {
                              return DropdownMenuItem<GfVisibilityType>(
                                value: value,
                                child: Text(value.toString().split('.')[1]),
                              );
                            }).toList(),
                          ),
                          if (!widget.isUploading[widget.files.indexOf(file)])
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.red),
                              onPressed: () => widget.onRemove!(file),
                            ),
                          if (widget.isUploading[widget.files.indexOf(file)])
                            const Icon(Icons.upload_rounded,
                                color: Colors.green),
                        ],
                      ),
                    ],
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
          style: const TextStyle(fontSize: 10),
        ),
      );
    }
  }
}
