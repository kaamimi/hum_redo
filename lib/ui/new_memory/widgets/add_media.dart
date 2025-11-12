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
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Image button
        TextButton.icon(
          onPressed: onImagePressed,
          icon: const Icon(Icons.photo_library_outlined, size: navBarIconSize),
          label: const Text('Image'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
          ),
        ),

        // Voice button
        TextButton.icon(
          onPressed: onVoicePressed,
          icon: const Icon(Icons.mic_none_outlined, size: navBarIconSize),
          label: const Text('Voice Note'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
