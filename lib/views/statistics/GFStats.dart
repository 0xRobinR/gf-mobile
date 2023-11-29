import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/components/cards/UserOverview.dart';
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
            SvgPicture.asset(
              "assets/logo/bnbchain.svg",
              height: 20,
            ),
            const SizedBox(width: 10),
            const TitleText(title: "Greenfield"),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const UserOverview(),
              const GFDivider(),
              const TitleText(title: "Greenfield Statistics"),
              Subtitle(title: "Here are some statistics about BNB Greenfield"),
              const SizedBox(height: 10),
              const GFStatsCard(),
              const SizedBox(height: 10),
              const TitleText(title: "My Statistics"),
              Subtitle(title: "Here are some statistics about you"),
              const SizedBox(height: 10),
              const GFUserStats(),
              const GFDivider(),
              const GFUserActivity()
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
