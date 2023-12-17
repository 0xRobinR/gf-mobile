import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/utils/getFileSize.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/models/CreateObjectApproval.dart';
import 'package:provider/provider.dart';

class FileEstimates extends StatefulWidget {
  final String bucketName;
  final List<File> files;

  const FileEstimates({Key? key, required this.bucketName, required this.files})
      : super(key: key);

  @override
  State<FileEstimates> createState() => _FileEstimates();
}

class _FileEstimates extends State<FileEstimates>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          const SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bucket: ",
              ),
              Text(
                widget.bucketName,
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Files: ",
              ),
              Text(
                widget.files.length.toString(),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Size: ",
              ),
              Text(
                getTotalSize(widget.files),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Estimated Cost: ",
              ),
              Text(
                "\$20.00",
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: FileTable(
              files: widget.files,
            ),
          ),
        ],
      ),
    );
  }
}

class FileTable extends StatefulWidget {
  final List<File> files;

  const FileTable({Key? key, required this.files}) : super(key: key);

  @override
  State<FileTable> createState() => _FileTableState();
}

class _FileTableState extends State<FileTable> {
  late List<File> sortedFiles;
  bool isAscending = true;
  int sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    sortedFiles = widget.files;
  }

  void _sort<T>(Comparable<T> Function(File file) getField, int columnIndex,
      bool ascending) {
    sortedFiles.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  List<DataRow> _createRows() {
    return widget.files.map((file) {
      final fileName = file.path.split('/').last;
      final smallFileName =
          fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName;
      return DataRow(
        cells: [
          DataCell(Text(smallFileName)), // File name
          DataCell(Text(getFileSize(file))), // File size
          DataCell(Text(getFileSize(file))), // File size
        ],
      );
    }).toList();
  }

  Future<Map<String, dynamic>> computeHashFromFile(File file) async {
    try {
      Uint8List fileBytes = await file.readAsBytes();
      String result = await GfSdk().computeHash(buffer: fileBytes);
      print(result);
      final resAsJson = jsonDecode(result);
      return {
        "contentLength": resAsJson['contentLength'],
        "expectedChecksums": resAsJson['expectedChecksums'],
        "redundancyVal": resAsJson['redundancyVal'],
      };
    } on PlatformException catch (e) {
      // Handle the exception
      print("Error occurred: ${e.message}");
      return {};
    }
  }

  String getFileType(String fileName) {
    var extension = fileName.split('.').last;

    const mimeTypes = {
      'json': 'application/json',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'bmp': 'image/bmp',
      'txt': 'text/plain',
      'html': 'text/html',
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'wav': 'audio/wav',
      'mp3': 'audio/mpeg',
      'mp4': 'video/mp4',
      'avi': 'video/x-msvideo',
      'mkv': 'video/x-matroska',
      'gz': 'application/gzip',
      'tar': 'application/x-tar',
      'zip': 'application/zip',
      '7z': 'application/x-7z-compressed',
      'rar': 'application/x-rar-compressed',
      'iso': 'application/x-iso9660-image',
      'img': 'application/x-iso9660-image',
      'exe': 'application/x-msdownload',
      'apk': 'application/vnd.android.package-archive',
      'deb': 'application/vnd.debian.binary-package',
      'rpm': 'application/x-rpm',
    };

    return mimeTypes[extension.toLowerCase()] ?? 'application/octet-stream';
  }

  getEstimate(File file) async {
    // try {
    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    final hash = await computeHashFromFile(file);
    final contentTypeOfFile = getFileType(file.path);

    String result = await GfSdk().createObjectEstimate(
        authKey: wallet.privateKey,
        opts: CreateObjectEstimate(
          contentLength: hash['contentLength'].toString(),
          objectName: file.path.split('/').last,
          bucketName: widget.files.first.path.split('/').last,
          creator: wallet.address,
          fileType: contentTypeOfFile,
        ));

    print(result);
    // } catch (e) {
    //   // Handle the exception
    //   print("Error occurred: ${e}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    final hash = getEstimate(widget.files.first);
    print(hash);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          sortColumnIndex: sortColumnIndex,
          sortAscending: isAscending,
          columns: [
            DataColumn(
                onSort: (columnIndex, ascending) => _sort<String>(
                    (file) => file.path.split('/').last,
                    columnIndex,
                    ascending),
                label: Text('File Name',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color))),
            DataColumn(
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>(
                    (file) => file.lengthSync(), columnIndex, ascending),
                label: Text('Size',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color))),
            DataColumn(
                numeric: true,
                onSort: (columnIndex, ascending) => _sort<num>(
                    (file) => file.lengthSync(), columnIndex, ascending),
                label: Text('Gas Cost',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color))),
          ],
          rows: _createRows(),
        ),
      ),
    );
  }
}
