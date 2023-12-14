import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/cards/ActionCards.dart';
import 'package:gf_mobile/components/cards/UserCard.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/BucketNotifier.dart';
import 'package:gf_mobile/state/FetchUserData.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class GFUserStats extends StatefulWidget {
  const GFUserStats({super.key});

  @override
  State<GFUserStats> createState() => _GFUserStatsState();
}

class _GFUserStatsState extends State<GFUserStats> {
  double balance = 0.0;
  double value = 0.0;
  double accountNumber = 0;

  bool isWalletConnected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initValues();
    });
  }

  void initValues() async {
    final wallet = Provider.of<AddressNotifier>(context, listen: false);
    if (wallet.address == "") {
      setState(() {
        balance = 0.0;
        value = 0.0;
      });
      return;
    }
    final userData = await getUserData(wallet);
    setState(() {
      balance = userData['bnbBalance'];
      value = userData['bnbValue'];
      accountNumber = double.parse(userData['accountNumber'].toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initValues();
    return Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          UserCard(
            title: "BNB Balance",
            value: balance,
            assetName: "assets/logo/bnbchain.svg",
            isSvg: true,
          ),
          UserCard(
              title: "BNB Value", value: value, icon: LineIcons.dollarSign),
          Consumer<BucketNotifier>(builder: (context, spNotifier, child) {
            return UserCard(
                title: "My Buckets",
                value: spNotifier.buckets.length.toDouble(),
                isInt: true,
                assetName: "assets/icons/bucket.svg",
                isSvg: true);
          }),
          UserCard(
              title: "Acc. Number",
              value: accountNumber,
              isInt: true,
              icon: Icons.receipt_long),
          ActionCards(
            title: "Create Bucket",
            value: "0",
            icon: Icons.create_new_folder,
            onTap: () {
              Get.toNamed("/create_bucket");
            },
          ),
          const ActionCards(
              title: "Upload File", value: "5", icon: Icons.upload_file),
        ]);
  }
}
