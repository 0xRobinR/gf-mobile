import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gf_mobile/components/grid/GGridItem.dart';

class GGridView extends StatelessWidget {
  final int itemCount;

  GGridView({super.key, required this.itemCount});

  final List<int> itemHeights = [200, 150, 250, 180, 220, 200, 280, 210];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = (screenWidth / 200).floor();

    return StaggeredGridView.countBuilder(
        crossAxisCount: columnCount <= 1 ? 2 : columnCount,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemCount: itemHeights.length,
        itemBuilder: (context, index) {
          return GGridItem(index: index);
        });
  }
}
