import 'package:flutter/material.dart';
import 'package:gf_mobile/hooks/useShowAddWalletModal.dart';

class AddWallet extends StatelessWidget {
  final bool withText;

  AddWallet({super.key, this.withText = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: withText
              ? Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    const Text(
                      "Add Wallet",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : Icon(
                  Icons.add,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
          onPressed: () {
            showAddWalletModal(context);
          },
        ),
      ],
    );
  }
}
