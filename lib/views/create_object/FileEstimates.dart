import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/utils/getFileMeta.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var file in widget.files) {
        getEstimate(file);
      }
    });
  }

  Future<Map<String, dynamic>> computeHashFromFile(File file) async {
    try {
      Uint8List fileBytes = await file.readAsBytes();
      String result = await GfSdk().computeHash(buffer: fileBytes);
      final resAsJson = jsonDecode(result);
      // print(resAsJson);
      return {
        "contentLength": resAsJson['contentLength'],
        "expectedChecksums": jsonDecode(resAsJson['expectCheckSums']),
        "redundancyVal": resAsJson['redundancyVal'],
      };
    } on PlatformException catch (e) {
      // Handle the exception
      print("Error occurred: ${e.message}");
      return {
        "contentLength": 0,
        "expectedChecksums": [],
        "redundancyVal": 0,
      };
    }
  }

  getEstimate(File file) async {
    try {
      final wallet = Provider.of<AddressNotifier>(context, listen: false);
      final hash = await computeHashFromFile(file);
      final contentTypeOfFile = getFileType(file.path);

      String result = await GfSdk().createObjectEstimate(
          authKey: "0x${wallet.privateKey}",
          opts: CreateObjectEstimate(
              contentLength: hash['contentLength'],
              objectName: file.path.split('/').last,
              bucketName: widget.bucketName,
              creator: wallet.address,
              fileType: contentTypeOfFile,
              expectedChecksums: hash['expectedChecksums']));

      print(result);
      final resJson = jsonDecode(result);
      if (resJson['error'] != null) {
        print(resJson['error']);
        return;
      }
    } catch (e) {
      // Handle the exception
      print("Error occurred: ${e}");
    }
  }

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
              bucketName: widget.bucketName,
            ),
          ),
        ],
      ),
    );
  }
}

class FileTable extends StatefulWidget {
  final List<File> files;
  final String bucketName;

  const FileTable({Key? key, required this.files, required this.bucketName})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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
