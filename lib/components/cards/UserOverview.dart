import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/SmallCard.dart';
import 'package:gf_mobile/config/urls.dart';
import 'package:gf_mobile/hooks/useShowAddWalletModal.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/views/add_wallet/AddWallet.dart';
import 'package:gf_mobile/views/add_wallet/ListWallet.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserOverview extends StatefulWidget {
  const UserOverview({super.key});

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressNotifier =
          Provider.of<AddressNotifier>(context, listen: false);
      addressNotifier.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Consumer<AddressNotifier>(builder:
                  (BuildContext context, AddressNotifier value, Widget? child) {
                return value.address == ""
                    ? const Text("Greenfield Mobile Wallet")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Consumer<AddressNotifier>(builder:
                              (BuildContext context, AddressNotifier value,
                                  Widget? child) {
                            return value.address == ""
                                ? const Text("")
                                : Column(
                                    children: [
                                      Text(
                                        "${value.address.substring(0, 6)}...${value.address.substring(value.address.length - 6, value.address.length)}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color),
                                      ),
                                      const Text(
                                        "current wallet",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                          }),
                          Consumer<AddressNotifier>(builder:
                              (BuildContext context, AddressNotifier value,
                                  Widget? child) {
                            return value.wallets.length > 1
                                ? ListWallet()
                                : const SizedBox();
                          })
                        ],
                      );
              }),
              const SizedBox(height: 10),
              Consumer<AddressNotifier>(
                builder: (BuildContext context, AddressNotifier value,
                    Widget? child) {
                  return value.address == ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              AddWallet(
                                withText: true,
                              ),
                            ])
                      : Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            SmallCard(
                                icon: LineIcons.alternateExchange,
                                value: "",
                                callback: () async {
                                  if (await canLaunchUrl(
                                      Uri.parse(bridgeUrl))) {
                                    await launchUrlString(bridgeUrl);
                                  }
                                }),
                            SmallCard(
                                icon: LineIcons.eye,
                                value: "",
                                callback: () async {
                                  print(await canLaunchUrl(
                                      Uri.parse(gfScan(value.address))));
                                  if (await canLaunchUrl(
                                      Uri.parse(gfScan(value.address)))) {
                                    await launchUrlString(
                                        gfScan(value.address));
                                  }
                                }),
                            SmallCard(
                              icon: Icons.add,
                              value: "",
                              callback: () {
                                showAddWalletModal(context);
                              },
                            ),
                          ],
                        );
                },
              ),
              // add overview text if wallet not added
              Consumer<AddressNotifier>(
                builder: (BuildContext context, AddressNotifier value,
                    Widget? child) {
                  return value.address == ""
                      ? const Text(
                          "Create/Import a wallet to get started, or view your wallet address",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
