import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class MultiFab extends StatefulWidget {
  const MultiFab({super.key});

  @override
  _MultiFabState createState() => _MultiFabState();
}

class _MultiFabState extends State<MultiFab>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.account_box),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.amber,
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.small,
        foregroundColor: Colors.deepOrangeAccent,
        backgroundColor: Colors.lightGreen,
        shape: const CircleBorder(),
      ),
      children: [
        FloatingActionButton.small(
          heroTag: null,
          child: const Icon(Icons.edit),
          onPressed: () {},
        ),
        FloatingActionButton.small(
          heroTag: null,
          child: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
