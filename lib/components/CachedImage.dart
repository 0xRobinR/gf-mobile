import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Loading.dart';

class CachedImage extends StatelessWidget {
  final String imagePath;

  const CachedImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the image is local or from the network
    if (Uri.parse(imagePath).isAbsolute) {
      // For network images
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        placeholder: (context, url) => GFLoader(
          dotColor: Theme.of(context).textTheme.bodySmall?.color,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      // For local images
      return CircleAvatar(
        backgroundImage: FileImage(File(imagePath)),
      );
    }
  }
}
