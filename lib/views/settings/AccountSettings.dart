import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/hooks/useAuthCall.dart';
import 'package:gf_mobile/hooks/useShowAddWalletModal.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressNotifier>(
        builder: (context, addressNotifier, child) {
      return Column(
        children: [
          GListTile(
              index: 0,
              icon: null,
              title: "add account",
              subtitle: "create/import new account",
              onTap: () {
                showAddWalletModal(context);
              },
              trailingIcon: const IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.grey,
                  size: 15,
                ),
                onPressed: null,
              )),
          if (addressNotifier.address != "")
            GListTile(
                index: 0,
                icon: null,
                onTap: () async {
                  Map<String, bool> auth = await checkAuthentication(context);
                  if (auth.isNotEmpty && auth["isAuthenticated"]!) {
                    addressNotifier.removeAddress();
                  } else if (auth.isNotEmpty && !auth["isAuthenticated"]!) {
                    Get.snackbar(
                      "Authentication Error",
                      "Invalid authentication detected. Please try again.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      icon: const Icon(Icons.lock, color: Colors.white),
                      shouldIconPulse: true,
                    );
                  }
                },
                title:
                    "remove account - ${addressNotifier.address.substring(0, 6)}...${addressNotifier.address.substring(addressNotifier.address.length - 4)}",
                subtitle:
                    "current account will be deleted (unsafe, backup recommended)",
                trailingIcon: IconButton(
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.grey,
                    size: 15,
                  ),
                  onPressed: () {},
                )),
        ],
      );
    });
  }
}
