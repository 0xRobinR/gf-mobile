import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/views/add_wallet/AddWalletModal.dart';
import 'package:gf_mobile/views/add_wallet/ImportWallet.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

String uint8ListToHex(Uint8List data) {
  return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

Future<void> showAddWalletModal(BuildContext context) async {
  final databaseNotifier = Provider.of<AddressNotifier>(context, listen: false);

  List walletArray = GetStorage().read<List>('walletArray') ?? [];
  String? selectedOption = await showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return const AddWalletModal();
    },
  );

  if (selectedOption == "import") {
    String? privateKey = await showPrivateKeyInput(context);
    if (privateKey != null && privateKey.isNotEmpty) {
      bool privateKeyExists =
          walletArray.any((wallet) => wallet['privateKey'] == privateKey);
      if (!privateKeyExists) {
        try {
          String address = EthPrivateKey.fromHex(privateKey).address.hex;
          await GetStorage().write('privateKey', privateKey);
          await GetStorage().write('address', address);

          final walletMap = {
            'privateKey': privateKey,
            'address': address,
          };
          walletArray.add(walletMap);
          await GetStorage().write('walletArray', walletArray);

          Get.snackbar(
            "Add Wallet",
            "Wallet added successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          databaseNotifier.updateAddress(address, privateKey);
        } catch (e) {
          Get.snackbar(
            "Import Wallet",
            "Error while adding wallet",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          "Add Wallet",
          "Wallet already exists",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  } else if (selectedOption == "create") {
    final privateKey = EthPrivateKey.createRandom(Random.secure());
    final address = privateKey.address;

    await GetStorage()
        .write('privateKey', uint8ListToHex(privateKey.privateKey));
    await GetStorage().write('address', address.hex);

    final walletMap = {
      'privateKey': uint8ListToHex(privateKey.privateKey),
      'address': address.hex,
    };
    walletArray.add(walletMap);
    await GetStorage().write('walletArray', walletArray);

    Get.snackbar(
      "Add Wallet",
      "${address.hex} added successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    databaseNotifier.updateAddress(
        address.hex, uint8ListToHex(privateKey.privateKey));
  }
}

Future<String?> showPrivateKeyInput(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return ImportWallet();
    },
  );
}
