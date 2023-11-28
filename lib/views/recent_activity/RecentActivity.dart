import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListView.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({super.key});

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Expanded(child: GListView())],
    );
  }
}
