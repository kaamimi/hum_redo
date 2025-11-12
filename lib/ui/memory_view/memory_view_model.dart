import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/data/repository.dart';

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepository();
});

final deleteMemoryProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  memoryId,
) async {
  final repository = ref.read(memoryRepositoryProvider);
  await repository.deleteMemory(memoryId);
});
