import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/views/create_object/FileEstimates.dart';
import 'package:gf_mobile/views/create_object/FileListDisplay.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pickFile();
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        List<File> _files = result.paths.map((path) => File(path!)).toList();
        setState(() {
          files = _files;
          isLoading = false;
        });
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

  Future<void> _uploadFiles(List<File> files) async {
    //
  }

  void _removeFile(File file) {
    setState(() {
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
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Estimated Cost',
                                      style: TextStyle(fontSize: 16)),
                                  Text('\$20.00',
                                      style: TextStyle(
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
              ),
              body: Column(
                children: [
                  FileListDisplay(
                    files: files,
                    onRemove: _removeFile,
                  ),
                ],
              ),
            ),
    );
  }
}
