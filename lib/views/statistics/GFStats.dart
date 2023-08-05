import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/components/grid/GGridView.dart';
import 'package:gf_mobile/components/list/GListView.dart';
import 'package:gf_mobile/views/home.dart';

class GFStats extends StatefulWidget {
  const GFStats({super.key});

  @override
  State<GFStats> createState() => _GFStatsState();
}

class _GFStatsState extends State<GFStats> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            height: 10,
          ),
          TitleText(
            title: 'Statistics',
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
