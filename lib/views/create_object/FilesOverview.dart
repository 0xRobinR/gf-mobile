import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/config/app.dart';
import 'package:gf_mobile/hooks/useFetchObjects.dart';
import 'package:gf_mobile/services/object/putObjectSync.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/utils/getFileCost.dart';
import 'package:gf_mobile/utils/getFileHash.dart';
import 'package:gf_mobile/utils/getFileMeta.dart';
import 'package:gf_mobile/views/create_object/FileEstimates.dart';
import 'package:gf_mobile/views/create_object/FileListDisplay.dart';
import 'package:gf_sdk/gf_sdk.dart';
import 'package:gf_sdk/interfaces/gf_global.dart';
import 'package:gf_sdk/models/CreateObjectApproval.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class FilesOverview extends StatefulWidget {
  final String bucketName;

  const FilesOverview({super.key, required this.bucketName});

  @override
  State<FilesOverview> createState() => _FilesOverviewState();
}

class _FilesOverviewState extends State<FilesOverview> {
  List<File> files = [];
  bool isUploading = false;
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PanelController _pc = PanelController();
  bool isBodyShown = false;
  List<double> gasFees = [];
  List<GfVisibilityType> visibilities = [];
  List<bool> isUploadingFiles = [];
  List<bool> isUploaded = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pickFile();
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        dialogTitle: 'Select files to upload to ${widget.bucketName}',
      );

      if (result != null) {
        List<File> _files = result.paths.map((path) => File(path!)).toList();
        setState(() {
          files = _files;
          isLoading = false;
          visibilities =
              List.generate(files.length, (index) => GfVisibilityType.private);
          isUploadingFiles = List.generate(files.length, (index) => false);
          isUploaded = List.generate(files.length, (index) => false);
        });
        fetchEstimates();
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      // Handle any exceptions
      Get.snackbar(
        'Error',
        'Error picking files: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  fetchEstimates() async {
    setState(() {
      gasFees = [];
    });
    files.forEach((file) async {
      final estimate = await getEstimate(
          file: file,
          context: context,
          bucketName: widget.bucketName,
          visibilityType: visibilities[files.indexOf(file)]);
      if (estimate['error'] != null) {
        print(estimate['error']);
        return;
      }
      setState(() {
        gasFees.add(double.parse(estimate['gasFee']));
      });
    });
  }

  fetchEstimateForFileAndUpdate(File file) async {
    final estimate = await getEstimate(
        file: file,
        context: context,
        bucketName: widget.bucketName,
        visibilityType: visibilities[files.indexOf(file)]);
    if (estimate['error'] != null) {
      print(estimate['error']);
      return;
    }
    setState(() {
      gasFees[files.indexOf(file)] = double.parse(estimate['gasFee']);
    });
  }

  updateVisibility(File file, GfVisibilityType visibility) {
    print("visibility $visibility");
    setState(() {
      visibilities[files.indexWhere((element) => element.path == file.path)] =
          visibility;
    });

    fetchEstimateForFileAndUpdate(file);
  }

  Future<void> _uploadFiles(List<File> files) async {
    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    setState(() {
      isUploading = true;
    });
    for (var file in files) {
      if (isUploaded[files.indexOf(file)]) {
        continue;
      }
      final hash = await computeHashFromFile(file);
      final contentTypeOfFile = getFileType(file.path);

      setState(() {
        isUploadingFiles[files.indexOf(file)] = true;
      });

      String result = await GfSdk().createObject(
          authKey: "0x${wallet.privateKey}",
          opts: CreateObjectEstimate(
              contentLength: hash['contentLength'],
              objectName: file.path.split('/').last,
              bucketName: widget.bucketName,
              creator: wallet.address,
              fileType: contentTypeOfFile,
              expectedChecksums: hash['expectedChecksums'],
              visibility: visibilities[files.indexOf(file)]));

      final resJson = jsonDecode(result);
      if (resJson['error'] != null) {
        try {
          final errorJson = resJson['error'];
          setState(() {
            isUploadingFiles[files.indexOf(file)] = false;
            isUploading = false;
          });
          Get.snackbar(
            'Error',
            'Error uploading file: ${errorJson['message']}',
            snackPosition: SnackPosition.BOTTOM,
          );
        } catch (e) {
          setState(() {
            isUploadingFiles[files.indexOf(file)] = false;
            isUploading = false;
          });
          Get.snackbar(
            'Error',
            'Error uploading file: ${resJson['error']}',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      } else {
        scheduleBackgroundUpload(
            filePath: file.path,
            bucketName: widget.bucketName,
            objectName: file.path.split('/').last,
            txHash: resJson['hash'],
            authKey: "0x${wallet.privateKey}");

        setState(() {
          isUploaded[files.indexOf(file)] = true;
        });
        // Get.snackbar(
        //   'Success',
        //   '${file.path.split('/').last} uploaded successfully',
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }
    }

    final objects = await useFetchObjects(bucketName: widget.bucketName);
    final bucketObjects =
        Provider.of<ObjectNotifier>(context, listen: false).objects;
    Provider.of<ObjectNotifier>(context, listen: false).setObjects({
      widget.bucketName: {...bucketObjects, "objects": objects},
    });

    if (isUploaded.every((element) => element == true)) {
      Get.back(
        result: {
          "bucketName": widget.bucketName,
          "uploaded": true,
        },
      );
    }

    // setState(() {
    //   isUploading = false;
    // });
  }

  void _removeFile(File file) {
    setState(() {
      visibilities.removeAt(files.indexOf(file));
      if (gasFees.length > files.indexOf(file)) {
        gasFees.removeAt(files.indexOf(file));
      }
      isUploadingFiles.removeAt(files.indexOf(file));
      isUploaded.removeAt(files.indexOf(file));
      files.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pc.isAttached && files.isEmpty) {
      _pc.close();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Files Overview"),
        actions: [
          if (files.length > 100)
            IconButton(
              onPressed: () {
                Get.snackbar(
                  'Error',
                  'You can only upload 10 files at a time',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.info_outline_rounded),
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: GFLoader(
                width: 50,
                dotColor: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            )
          : SlidingUpPanel(
              controller: _pc,
              minHeight: 65,
              onPanelOpened: () {
                setState(() {
                  isBodyShown = true;
                });
              },
              onPanelClosed: () {
                setState(() {
                  isBodyShown = false;
                });
              },
              onPanelSlide: (double pos) => setState(() {
                setState(() {
                  isBodyShown = pos > 0;
                });
              }),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.white.withOpacity(.5),
                ),
              ],
              parallaxEnabled: true,
              parallaxOffset: .5,
              // minHeight: 40,
              isDraggable: false,
              header: files.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text("No gas estimation found!"),
                        ],
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          if (isBodyShown) {
                            _pc.close();
                          } else {
                            _pc.open();
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Gas Estimation',
                                ),
                                if (isBodyShown)
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                if (!isBodyShown)
                                  const Icon(Icons.keyboard_arrow_up_rounded),
                              ],
                            ),
                            if (!isBodyShown)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text('Estimated Cost',
                                      style: TextStyle(fontSize: 16)),
                                  gasFees.isEmpty
                                      ? Center(
                                          child: GFLoader(
                                          width: 30,
                                          dotColor: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                        ))
                                      : Text(
                                          '${gasFees.isNotEmpty ? (gasFees.reduce((value, element) => value + element)).toStringAsFixed(6) : 0.00} $feeSymbol',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
              panelBuilder: () => FileEstimates(
                bucketName: widget.bucketName,
                files: files,
                gasFees: gasFees,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    FileListDisplay(
                      files: files,
                      onRemove: _removeFile,
                      onVisibilityChange: updateVisibility,
                      visibilities: visibilities,
                      isUploading: isUploadingFiles,
                      isUploaded: isUploaded,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (files.length <= 100)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pickFile();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  files.isNotEmpty
                                      ? Icons.replay_circle_filled_rounded
                                      : Icons.add_circle_rounded,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "${files.isEmpty ? "Add" : "Change"} Files",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          if (files.length <= 100)
                            const SizedBox(
                              width: 20.0,
                            ),
                          if (files.length <= 100)
                            ElevatedButton(
                              onPressed: isUploading
                                  ? null
                                  : () {
                                      if (files.isNotEmpty) {
                                        _uploadFiles(files);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'No files selected',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                              child: isUploading
                                  ? const GFLoader(
                                      width: 20,
                                      dotColor: Colors.black,
                                    )
                                  : Row(
                                      children: [
                                        const Icon(
                                          Icons.cloud_upload_rounded,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Upload to ${widget.bucketName}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                            ),
                        ],
                      ),
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    // if (files.length <= 100)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       ElevatedButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             visibilities = List.generate(files.length,
                    //                 (index) => GfVisibilityType.private);
                    //           });
                    //           fetchEstimates();
                    //         },
                    //         child: const Row(
                    //           children: [
                    //             Icon(
                    //               Icons.lock_rounded,
                    //               color: Colors.black,
                    //             ),
                    //             SizedBox(
                    //               width: 5.0,
                    //             ),
                    //             Text(
                    //               "Make All Private",
                    //               style: TextStyle(color: Colors.black),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         width: 20.0,
                    //       ),
                    //       ElevatedButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             visibilities = List.generate(files.length,
                    //                 (index) => GfVisibilityType.public);
                    //           });
                    //           fetchEstimates();
                    //         },
                    //         child: const Row(
                    //           children: [
                    //             Icon(
                    //               Icons.lock_open_rounded,
                    //               color: Colors.black,
                    //             ),
                    //             SizedBox(
                    //               width: 5.0,
                    //             ),
                    //             Text(
                    //               "Make All Public",
                    //               style: TextStyle(color: Colors.black),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    const SizedBox(
                      height: 250,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
