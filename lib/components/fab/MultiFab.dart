import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gf_mobile/theme/themes.dart';

class MultiFab extends StatefulWidget {
  const MultiFab({super.key});

  @override
  MultiFabState createState() => MultiFabState();
}

class MultiFabState extends State<MultiFab>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      children: [
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: textColor,
          child: const Icon(Icons.edit),
          onPressed: () {},
        ),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: textColor,
          child: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
