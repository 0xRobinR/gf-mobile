import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/ActionCards.dart';
import 'package:gf_mobile/components/cards/UserCard.dart';
import 'package:line_icons/line_icons.dart';

class GFUserStats extends StatefulWidget {
  const GFUserStats({super.key});

  @override
  State<GFUserStats> createState() => _GFUserStatsState();
}

class _GFUserStatsState extends State<GFUserStats> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: const [
        UserCard(
          title: "BNB Balance",
          value: "0.5",
          assetName: "assets/logo/bnbchain.svg",
          isSvg: true,
        ),
        UserCard(
            title: "BNB Value",
            value: "${5 * 241.5}",
            icon: LineIcons.dollarSign),
        UserCard(
            title: "My Buckets",
            value: "5",
            assetName: "assets/icons/bucket.svg",
            isSvg: true),
        UserCard(title: "Txn Count", value: "5", icon: Icons.receipt_long),
        ActionCards(
            title: "Create Bucket", value: "5", icon: Icons.create_new_folder),
        ActionCards(title: "Upload File", value: "5", icon: Icons.upload_file),
      ],
    );
  }
}
