import 'package:flutter/material.dart';
import 'package:gf_mobile/models/Onboard/OnboardModel.dart';

final onBoardData = [
  OnBoardModel(
      bgColor: Colors.black,
      title: "Storage Flexibility",
      description:
          "Storage providers can choose to store data anywhere, from decentralized terminals to centralized storage services.",
      image: Icons.storage),
  OnBoardModel(
      bgColor: const Color(0xFF7E0707),
      title: "Data Configuration",
      description: 'Users can customize data, data "buckets", and permissions.',
      image: Icons.window),
  OnBoardModel(
      bgColor: const Color(0xFF06516B),
      title: "Native Smart-Contract Ecosystem",
      description:
          "BNB Greenfield's stored data can be easily integrated into the thriving smart contract-enabled BNB Chain ecosystem.",
      image: Icons.receipt_long)
];
