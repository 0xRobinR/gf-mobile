import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/components/list/GListView.dart';

class GFUserActivity extends StatefulWidget {
  const GFUserActivity({super.key});

  @override
  State<GFUserActivity> createState() => _GFUserActivityState();
}

class _GFUserActivityState extends State<GFUserActivity> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText(title: "My Activity"),
        Subtitle(title: "Here is your activity on Greenfield"),
        const SizedBox(height: 10),
        const GListView()
      ],
    );
  }
}
