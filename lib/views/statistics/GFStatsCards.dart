import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/StatisticCard.dart';

class GFStatsCard extends StatefulWidget {
  const GFStatsCard({super.key});

  @override
  State<GFStatsCard> createState() => _GFStatsCardState();
}

class _GFStatsCardState extends State<GFStatsCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  StatisticCard(
                    title: "Current Block Height",
                    value: "1,000,000",
                    icon: Icons.height,
                  ),

                  StatisticCard(
                    title: "Buckets Created",
                    value: "2103",
                    icon: Icons.cabin,
                  ),

                  StatisticCard(
                    title: "Total Addresses",
                    value: "15,209",
                    icon: Icons.people,
                  ),

                  StatisticCard(
                    title: "Total Transactions",
                    value: "155,112,219",
                    icon: Icons.receipt,
                  ),

                  StatisticCard(
                    title: "Total Objects",
                    value: "30,403",
                    icon: Icons.data_object,
                  ),
                ],
              ),
            ),
          );
  }
}
