import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/views/create_object/CreateObject.dart';
import 'package:provider/provider.dart';

class GFBucketOverview extends StatefulWidget {
  final String bucketName;

  const GFBucketOverview({super.key, required this.bucketName});

  @override
  State<GFBucketOverview> createState() => _GFBucketOverviewState();
}

class _GFBucketOverviewState extends State<GFBucketOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bucketName} objects"),
        centerTitle: true,
        actions: [],
      ),
      body: Column(
        children: [
          Consumer<ObjectNotifier>(
            builder: (context, objectNotifier, child) {
              final objects = objectNotifier.objects[widget.bucketName];
              return objects['objects'].length == 0
                  ? Center(
                      child: Text("No objects found"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: objects['objects'].length,
                      itemBuilder: (context, index) {
                        final object = objects['objects'][index];
                        final visibility =
                            object['visibility'] == "VISIBILITY_TYPE_PRIVATE"
                                ? "Private"
                                : "Public";

                        final smallObjectName =
                            object['object_name'].length > 20
                                ? object['object_name'].substring(0, 8) +
                                    "..." +
                                    object['object_name'].substring(
                                        object['object_name'].length - 8,
                                        object['object_name'].length)
                                : object['object_name'];
                        return GListTile(
                          index: index,
                          title: smallObjectName,
                          icon: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_present),
                            ],
                          ),
                          subtitle:
                              "${(double.parse(object['payload_size']) / 1024).toStringAsFixed(2)} KB\n$visibility"
                              "\n${formatDate(DateTime.fromMillisecondsSinceEpoch(int.parse(object['create_at'].toString()) * 1000), [
                                d,
                                ' ',
                                M,
                                ' ',
                                hh,
                                ':',
                                nn,
                                ' ',
                                am
                              ])}",
                          trailingIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.download),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(visibility == "Private"
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.delete)),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            // Get.to(() => GFObjectOverview(
                            //       bucketName: widget.bucketName,
                            //       objectName: object['name'],
                            //     ));
                          },
                        );
                      },
                    );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => const CreateObject());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
