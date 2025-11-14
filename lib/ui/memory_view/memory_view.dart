import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/data/models/memory.dart';
import '/ui/common/recents_view_model.dart';
import './widgets/memory_image.dart';
import './widgets/memory_note.dart';
import './widgets/memory_metadata.dart';
import './memory_view_model.dart';

class MemoryView extends ConsumerWidget {
  final Memory memory;

  const MemoryView({super.key, required this.memory});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete memory?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(deleteMemoryProvider(memory.id).future);
      ref.invalidate(recentMemoriesProvider);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
          MenuAnchor(
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
              MenuItemButton(
                onPressed: () {},
                leadingIcon: const Icon(Icons.local_offer_outlined),
                child: const Text('Tags'),
              ),
              MenuItemButton(
                onPressed: () => _handleDelete(context, ref),
                leadingIcon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (memory.imageUrl != null)
              MemoryImagePreview(imageUrl: memory.imageUrl!),
            MemoryMetadata(memory: memory),
            if (memory.note != null && memory.note!.isNotEmpty)
              MemoryNote(note: memory.note!),
          ],
        ),
      ),
    );
  }
}
