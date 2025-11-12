import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/data/repository.dart';
import '/core/data/models/memory.dart';

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepository();
});

final allMemoriesProvider = FutureProvider<List<Memory>>((ref) async {
  final repository = ref.read(memoryRepositoryProvider);
  return await repository.getAllMemories();
});
