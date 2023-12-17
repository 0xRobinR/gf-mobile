import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/hooks/useFetchObjects.dart';
import 'package:gf_mobile/routes.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/theme/themes.dart';
import 'package:provider/provider.dart';

class GFBucketTile extends StatefulWidget {
  final String title;
  final int createdAt;
  final int block;

  const GFBucketTile(
      {super.key,
      required this.title,
      required this.createdAt,
      required this.block});

  @override
  State<GFBucketTile> createState() => _GFBucketTileState();
}

class _GFBucketTileState extends State<GFBucketTile> {
  int objectCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchObjectCount();
    });
  }

  fetchObjectCount() async {
    final objects = await useFetchObjects(bucketName: widget.title);
    Provider.of<ObjectNotifier>(context, listen: false).setObjects({
      widget.title: {
        "objects": objects,
        "block": widget.block,
        "createdAt": widget.createdAt,
      },
    });

    setState(() {
      objectCount = objects.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // format date in dd-MMM-YY h:m a format
    return Consumer<ObjectNotifier>(builder: (context, objectNotifier, child) {
      return GListTile(
          index: 0,
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder, color: bnbColor),
            ],
          ),
          title: widget.title,
          onTap: () {
            Get.toNamed(Routes.gfBucketOverview, arguments: {
              "bucketName": widget.title,
            });
          },
          subtitle:
              "created on ${formatDate(DateTime.fromMillisecondsSinceEpoch(widget.createdAt), [
                d,
                ' ',
                M,
                ' '
              ])} with ${objectNotifier.objects[widget.title]?["objects"]?.length ?? "0"} objects",
          trailingIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {}),
            ],
          ));
    });
  }
}
