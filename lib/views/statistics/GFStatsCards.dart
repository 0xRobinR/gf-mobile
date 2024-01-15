import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/StatisticCard.dart';
import 'package:gf_mobile/services/statistics/fetchGFStats.dart';
import 'package:gf_mobile/state/FetchGFData.dart';

class GFStatsCard extends StatefulWidget {
  const GFStatsCard({super.key});

  @override
  State<GFStatsCard> createState() => _GFStatsCardState();
}

class _GFStatsCardState extends State<GFStatsCard> {
  late Timer _timer;

  String blockHeight = "0";
  String totalBuckets = "0";
  String totalObjects = "0";
  String totalTransactions = "0";

  @override
  void initState() {
    super.initState();

    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (Timer t) => initValues());
    initValues();
  }

  Future<void> initValues() async {
    final String? stats = await getGFStats();
    final String buckets = await getBucketsCreated();
    final String objects = await getObjectCount();
    final String transactions = await getTransactionCount();
    try {
      final Map<String, dynamic>? statsMap = jsonDecode(stats ?? "{}");

      setState(() {
        blockHeight = statsMap!["currentBlock"];
        totalBuckets = buckets;
        totalObjects = objects;
        totalTransactions = transactions;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            StatisticCard(
              title: "Current Block Height",
              value: blockHeight,
              icon: Icons.height,
            ),
            StatisticCard(
              title: "Buckets Created",
              value: totalBuckets,
              icon: Icons.cabin,
            ),
            // const StatisticCard(
            //   title: "Total Addresses",
            //   value: "15209",
            //   icon: Icons.people,
            // ),
            StatisticCard(
              title: "Total Transactions",
              value: totalTransactions,
              icon: Icons.receipt,
            ),
            StatisticCard(
              title: "Total Objects",
              value: totalObjects,
              icon: Icons.data_object,
            ),
          ],
        ),
      ),
    );
  }
}
