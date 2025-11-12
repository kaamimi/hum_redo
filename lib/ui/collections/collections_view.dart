import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './collections_view_model.dart';
import './widgets/memory_tile.dart';

class CollectionsView extends ConsumerWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(allMemoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Collections')),
      body: memoriesAsync.when(
        data: (memories) {
          if (memories.isEmpty) {
            return Center(
              child: Text(
                'No memories yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return ListView.builder(
            itemCount: memories.length,
            itemBuilder: (context, index) {
              return MemoryTile(memory: memories[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading memories: $error')),
      ),
    );
  }
}
