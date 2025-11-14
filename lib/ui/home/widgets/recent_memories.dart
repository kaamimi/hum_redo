import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/ui/common/recents_view_model.dart';
import '/ui/common/memory_tile.dart';

class RecentMemories extends ConsumerWidget {
  const RecentMemories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentsAsync = ref.watch(recentMemoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Recents',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        recentsAsync.when(
          data: (memories) {
            if (memories.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No memories yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }
            return Column(
              children: memories
                  .map((memory) => MemoryTile(memory: memory))
                  .toList(),
            );
          },
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => SizedBox(
            height: 100,
            child: Center(child: Text('Error loading memories: $error')),
          ),
        ),
      ],
    );
  }
}
