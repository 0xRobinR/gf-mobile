import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gf_mobile/theme/themes.dart';

class GGridItem extends StatelessWidget {
  final int index;
  GGridItem({super.key, required this.index});

  final Random _random = Random();
  final int itemCount = 20;

    int getRandomSize(int min, int max) => min + _random.nextInt(max - min);

  @override
  Widget build(BuildContext context) {


    String imageUrl = 'https://picsum.photos/${getRandomSize(200, 400)}/${getRandomSize(200, 600)}';

    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          color: primaryThemeData.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 10),
            // fetch random pic from url

            Image(image: NetworkImage(imageUrl, scale: 1.0)),
            Text('Item $index'),
            const Text('uploaded on 2021-09-01')
          ]
        ),
      ),
    );
  }
}
