import 'package:flutter/material.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/views/create_object/CreateObject.dart';
import 'package:gf_mobile/views/my_files/GFFileObject.dart';
import 'package:provider/provider.dart';

class GFBucketOverview extends StatefulWidget {
  final String bucketName;

  const GFBucketOverview({super.key, required this.bucketName});

  @override
  State<GFBucketOverview> createState() => _GFBucketOverviewState();
}

class _GFBucketOverviewState extends State<GFBucketOverview> {
  Map<int, bool> isDeleting = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bucketName} objects"),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ObjectNotifier>(
              builder: (context, objectNotifier, child) {
                final objects = objectNotifier.objects[widget.bucketName];
                if (objects == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return objects['objects']?.length == 0
                    ? const Center(
                        child: Text("No objects found"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: objects['objects'].length,
                        itemBuilder: (context, index) {
                          final object = objects['objects'][index];

                          return GFFileObject(
                              bucketName: widget.bucketName,
                              object: object,
                              index: index);
                        },
                      );
              },
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => CreateObject(
                    bucketName: widget.bucketName,
                  ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
