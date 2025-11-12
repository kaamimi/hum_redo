import 'dart:io';
import 'package:flutter/material.dart';

class MemoryImagePreview extends StatelessWidget {
  final String imageUrl;

  const MemoryImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 300,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 48),
            ),
          );
        },
      ),
    );
  }
}
