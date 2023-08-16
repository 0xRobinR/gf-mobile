import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/components/cards/StatisticCard.dart';
import 'package:gf_mobile/components/cards/UserOverview.dart';
import 'package:gf_mobile/components/grid/GGridView.dart';
import 'package:gf_mobile/components/list/GListView.dart';
import 'package:gf_mobile/views/home.dart';
import 'package:gf_mobile/views/statistics/GFStatsCards.dart';
import 'package:gf_mobile/views/statistics/GFUserStats.dart';
import 'package:gf_mobile/views/user_activity/GFUserActivity.dart';

import '../../components/GFDivider.dart';

class GFStats extends StatefulWidget {
  const GFStats({super.key});

  @override
  State<GFStats> createState() => _GFStatsState();
}

class _GFStatsState extends State<GFStats> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo/bnbchain.svg", height: 20,),
              const SizedBox(width: 10),
              const TitleText(title: "Greenfield"),
            ],
          ),
          centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            children: const [
              SizedBox(height: 20),
              UserOverview(),
              GFDivider(),
              TitleText(title: "Greenfield Statistics"),
              Subtitle(title: "Here are some statistics about Greenfield"),
              SizedBox(height: 10),
              GFStatsCard(),
              SizedBox(height: 10),
              TitleText(title: "My Statistics"),
              Subtitle(title: "Here are some statistics about you"),
              SizedBox(height: 10),
              GFUserStats(),
              GFDivider(),
              GFUserActivity()
            ],
        ),
      ),
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
