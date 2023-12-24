import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gf_mobile/config/app.dart';
import 'package:gf_mobile/utils/getFileCost.dart';
import 'package:gf_mobile/utils/getFileSize.dart';

class FileEstimates extends StatefulWidget {
  final String bucketName;
  final List<File> files;
  final List<double> gasFees;

  const FileEstimates(
      {Key? key,
      required this.bucketName,
      required this.files,
      required this.gasFees})
      : super(key: key);

  @override
  State<FileEstimates> createState() => _FileEstimates();
}

class _FileEstimates extends State<FileEstimates>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estimated Cost: ",
              ),
              Text(
                "${widget.gasFees.isNotEmpty ? (widget.gasFees.reduce((value, element) => value + element)).toStringAsFixed(6) : 0.00} $feeSymbol",
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
              gasFees: widget.gasFees,
            ),
          ),
        ],
      ),
    );
  }
}

class FileTable extends StatefulWidget {
  final List<File> files;
  final List<double> gasFees;
  final String bucketName;

  const FileTable(
      {Key? key,
      required this.files,
      required this.bucketName,
      required this.gasFees})
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
      final gasFee = widget.gasFees.isNotEmpty &&
              widget.gasFees.length > widget.files.indexOf(file)
          ? widget.gasFees[widget.files.indexOf(file)]
          : 0.00;
      return DataRow(
        cells: [
          DataCell(Text(smallFileName)), // File name
          DataCell(Text(getFileSize(file))), // File size
          DataCell(gasFee == 0.00
              ? const Center(
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text("$gasFee $feeSymbol")), // File size
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

class CostWidget extends StatefulWidget {
  final File file;
  final String bucketName;

  const CostWidget({super.key, required this.file, required this.bucketName});

  @override
  State<CostWidget> createState() => _CostWidgetState();
}

class _CostWidgetState extends State<CostWidget> {
  double gasFee = 0.00;
  double gasPrice = 0.00;
  double gasLimit = 0.00;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getEstimateForFile(widget.file);
    });
  }

  getEstimateForFile(File file) async {
    final estimate = await getEstimate(
        file: file, context: context, bucketName: widget.bucketName);
    if (estimate['error'] != null) {
      print(estimate['error']);
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      gasFee = estimate['gasFee'];
      gasPrice = estimate['gasPrice'];
      gasLimit = estimate['gasLimit'];
      isLoading = false;
    });
  }

  String gasCost() {
    if (gasFee == 0.00 || gasPrice == 0.00 || gasLimit == 0.00) {
      return "error";
    }
    return "${(gasFee).toStringAsFixed(6)} $feeSymbol";
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(),
            ),
          )
        : Text(
            gasCost(),
            overflow: TextOverflow.ellipsis,
          );
  }
}
