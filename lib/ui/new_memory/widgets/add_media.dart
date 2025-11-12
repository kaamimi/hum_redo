import 'package:flutter/material.dart';

import '/core/constants.dart';

class AddMedia extends StatelessWidget {
  final VoidCallback onImagePressed;
  final VoidCallback onVoicePressed;

  const AddMedia({
    super.key,
    required this.onImagePressed,
    required this.onVoicePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: onImagePressed,
          label: Text('Image'),
          icon: const Icon(Icons.photo_library_outlined, size: navBarIconSize),
        ),
        TextButton.icon(
          onPressed: onVoicePressed,
          label: Text('Voice Note'),
          icon: const Icon(Icons.mic_none_outlined, size: navBarIconSize),
        ),
      ],
    );
  }
}
