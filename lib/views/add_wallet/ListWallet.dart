import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/hooks/useAuthCall.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/utils/showSnackbar.dart';
import 'package:provider/provider.dart';

class ListWallet extends StatelessWidget {
  const ListWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_drop_down_rounded),
      onPressed: () => _showWalletsModal(context),
    );
  }

  void _showWalletsModal(BuildContext context) {
    final addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);

    final currentAddress = addressNotifier.address;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Select Wallet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: addressNotifier.wallets.length,
            itemBuilder: (BuildContext context, int index) {
              final wallet = addressNotifier.wallets[index];
              return GListTile(
                  backgroundColor: currentAddress == wallet['address']
                      ? Colors.green[100]
                      : null,
                  index: index,
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      currentAddress == wallet['address']
                          ? Icon(Icons.check_circle)
                          : Icon(Icons.account_balance_wallet_rounded),
                    ],
                  ),
                  title: wallet['address'] != null && wallet['address'] != ""
                      ? "${wallet['address']?.substring(0, 6)}...${wallet['address']?.substring(wallet['address']!.length - 6, wallet['address']?.length)}"
                      : 'Unknown Address',
                  onTap: currentAddress == wallet['address']
                      ? null
                      : () {
                          addressNotifier.selectAddress(wallet['address'] ?? "",
                              wallet['privateKey'] ?? "");
                          showSnackbar(
                              title: "Wallet changed",
                              message:
                                  "current wallet changed to ${wallet['address']}",
                              color: Colors.green);
                          Navigator.pop(context);
                        },
                  subtitle: 'Wallet ${index + 1}',
                  trailingIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          Map<String, bool> auth = await checkAuthentication(
                              context,
                              isForcePin: false);
                          if (auth.isNotEmpty &&
                              auth["isAuthEnabled"]! &&
                              auth["isAuthenticated"]!) {
                            Clipboard.setData(ClipboardData(
                                text: wallet['privateKey'] ?? "Unknown Key"));
                            showSnackbar(
                              title: "Copied to clipboard",
                              message: "Don't share with anyone",
                              color: Colors.green,
                              textColor: Colors.white,
                            );
                          } else if (auth.isNotEmpty &&
                              auth["isAuthEnabled"]!) {
                            // Timer(const Duration(milliseconds: 500), () {
                            //   showSnackbar(
                            //     title: "Authentication Error",
                            //     message:
                            //         "Invalid authentication detected. Please try again.",
                            //     color: Colors.red,
                            //     textColor: Colors.white,
                            //   );
                            // });
                          }
                        },
                      ),
                    ],
                  ));
            },
          ))
        ]);
      },
    );
  }
}
