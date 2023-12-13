import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/list/GListTile.dart';
import 'package:gf_mobile/hooks/useAuthCall.dart';
import 'package:gf_mobile/hooks/useShowAddWalletModal.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressNotifier>(
        builder: (context, addressNotifier, child) {
      final authNotifier = Provider.of<AuthNotifier>(context);
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
          if (addressNotifier.address != "" && authNotifier.isLoggedIn)
            GListTile(
                index: 0,
                icon: null,
                onTap: () async {
                  // alert for the action to be taken
                  bool? shouldRemove = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Removal'),
                        content: const Text(
                            'Are you sure you want to remove this wallet?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Remove'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldRemove == true) {
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
                  }
                },
                title:
                    "remove account - ${addressNotifier.address.substring(0, 6)}...${addressNotifier.address.substring(addressNotifier.address.length - 4)}",
                subtitle:
                    "current account will be deleted (unsafe, backup recommended)",
                trailingIcon: const IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.grey,
                    size: 15,
                  ),
                  onPressed: null,
                )),
        ],
      );
    });
  }
}
