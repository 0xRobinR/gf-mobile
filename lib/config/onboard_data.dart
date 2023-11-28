import 'package:flutter/material.dart';
import 'package:gf_mobile/models/Onboard/OnboardModel.dart';

final onBoardData = [
  OnBoardModel(
      bgColor: Colors.black,
      title: "Website Hosting",
      description:
          "BNB Greenfield offers APIs and employs concepts akin to Amazon S3, enabling users to effortlessly deploy their websites through its platform and manage payments seamlessly with BNB.",
      image: Icons.webhook_sharp),
  OnBoardModel(
      bgColor: const Color(0xFF7E0707),
      title: "Personal Cloud Storage",
      description:
          "Utilizing BNB Greenfield, users can establish personal network drives to securely upload and download encrypted files, photos, and videos across desktop and mobile devices, all while using their private keys for access.",
      image: Icons.storage),
  OnBoardModel(
      bgColor: const Color(0xFF06516B),
      title: "Blockchain Data Storage",
      description:
          "L1s hold vast amounts of historical data, including dead or dormant content. BNB Greenfield can store this data to decrease L1 latency and enhance data accessibility while enabling smooth retrieval of dead or dormant data when required. Additionally, BNB Greenfield offers a cost-effective solution for storing L2-Rollup transaction data.",
      image: Icons.link)
];
