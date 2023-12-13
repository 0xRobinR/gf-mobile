import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbar(
    {required String title,
    required String message,
    Color? color,
    Color? textColor}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color,
    colorText: textColor,
    icon: const Icon(Icons.info, color: Colors.white),
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    duration: const Duration(milliseconds: 1200),
    isDismissible: true,
    dismissDirection: DismissDirection.down,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
