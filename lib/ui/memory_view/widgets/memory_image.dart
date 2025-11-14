import 'dart:io';
import 'package:flutter/material.dart';

class MemoryImagePreview extends StatelessWidget {
  final String imageUrl;

  const MemoryImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imageUrl),
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: 300,
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined, size: 48),
          ),
        );
      },
    );
  }
}
