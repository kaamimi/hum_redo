import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/data/repository.dart';
import '/core/data/models/memory.dart';

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepository();
});

final recentMemoriesProvider = FutureProvider<List<Memory>>((ref) async {
  final repository = ref.read(memoryRepositoryProvider);
  final memories = await repository.getAllMemories();

  // Sort by creation date descending and take all memories
  memories.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  // return memories.take(5).toList();
  return memories;
});
