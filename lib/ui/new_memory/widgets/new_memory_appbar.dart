import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewMemoryAppbar extends StatelessWidget implements PreferredSizeWidget {
  const NewMemoryAppbar({
    super.key,
    required this.hasContent,
    required this.selectedDate,
    required this.onDateChanged,
    this.onSavePressed,
    this.onImagePressed,
    this.onVoicePressed,
    this.onTagsPressed,
    this.hasImage = false,
    this.hasVoiceNote = false,
  });

  final bool hasContent;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final Future<void> Function()? onSavePressed;
  final VoidCallback? onImagePressed;
  final VoidCallback? onVoicePressed;
  final VoidCallback? onTagsPressed;
  final bool hasImage;
  final bool hasVoiceNote;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final checkIconColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.onInverseSurface
        : Theme.of(context).colorScheme.onSurface;

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null) onDateChanged(picked);
    }

    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: pickDate,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  DateFormat("EE, MMM d yyyy").format(selectedDate),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (hasContent)
          IconButton.filledTonal(
            onPressed: onSavePressed,
            icon: Icon(Icons.check, color: checkIconColor),
          ),
        _buildMoreMenu(),
      ],
    );
  }

  Widget _buildMoreMenu() {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert_rounded),
        );
      },
      menuChildren: [
        if (!hasImage)
          MenuItemButton(
            onPressed: onImagePressed,
            leadingIcon: const Icon(Icons.image_outlined),
            child: const Text("Image"),
          ),
        if (!hasVoiceNote)
          MenuItemButton(
            onPressed: onVoicePressed,
            leadingIcon: const Icon(Icons.mic_none_outlined),
            child: const Text("Voice Note"),
          ),
        MenuItemButton(
          onPressed: onTagsPressed,
          leadingIcon: const Icon(Icons.local_offer_outlined),
          child: const Text("Tags"),
        ),
      ],
    );
  }
}
