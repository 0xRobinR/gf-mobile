import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';

class GListView extends StatelessWidget {
  const GListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        GListTile(),
        GListTile(),
        GListTile(),
        GListTile(),
        GListTile(),
        GListTile(),
      ],
    );
  }
}
