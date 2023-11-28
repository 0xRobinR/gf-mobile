import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/SmallCard.dart';
import 'package:gf_mobile/config/urls.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/views/add_wallet/AddWallet.dart';
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
    final addressNotifier = Provider.of<AddressNotifier>(
        context, listen: false);
    addressNotifier.loadData();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Theme
                          .of(context)
                          .textTheme
                          .titleMedium
                          ?.color,
                    ),
                    onPressed: () {},
                  ),
                  Consumer<AddressNotifier>(builder: (BuildContext context,
                      AddressNotifier value, Widget? child) {
                    return value.address == ""
                        ? const Text("-")
                        : Text(
                      "${value.address.substring(0, 6)}...${value.address
                          .substring(value.address.length - 6, value.address
                          .length)}",
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .textTheme
                              .titleMedium
                              ?.color),
                    );
                  }),
                  AddWallet(),
                ],
              ),
              Consumer<AddressNotifier>(
                builder: (BuildContext context, AddressNotifier value,
                    Widget? child) {
                  return value.address == ""
                      ? const Text("add wallet")
                      : Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      SmallCard(
                          icon: LineIcons.plusCircle,
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
                            if (await canLaunchUrl(
                                Uri.parse(gfScan("address")))) {
                              await launchUrlString(gfScan("address"));
                            }
                          }),
                      SmallCard(icon: LineIcons.download, value: ""),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
