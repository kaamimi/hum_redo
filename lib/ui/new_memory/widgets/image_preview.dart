import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback? onLongPress;

  const ImagePreview({super.key, required this.image, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    if (image == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onLongPress: onLongPress, child: Image.file(image!)),
      ),
    );
  }
}
