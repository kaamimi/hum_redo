import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '/core/services/image_handler.dart';
import '/core/data/repository.dart';
import '/core/data/models/memory.dart';

final imageHandlerProvider = Provider<ImageHandler>((ref) => ImageHandler());

final pickImageProvider = FutureProvider.autoDispose<File?>((ref) async {
  final imageHandler = ref.read(imageHandlerProvider);
  return await imageHandler.pickFromGallery();
});

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepository();
});

final saveMemoryProvider = FutureProvider.autoDispose
    .family<void, ({String? note, File? imageFile, DateTime createdAt})>((
      ref,
      params,
    ) async {
      final repository = ref.read(memoryRepositoryProvider);
      final imageHandler = ref.read(imageHandlerProvider);

      String? savedImagePath;
      if (params.imageFile != null) {
        savedImagePath = await imageHandler.saveImageToAppDirectory(
          params.imageFile!,
        );
      }

      const uuid = Uuid();
      final memory = Memory(
        id: uuid.v4(),
        createdAt: params.createdAt,
        note: params.note,
        imageUrl: savedImagePath,
      );

      await repository.createMemory(memory);
    });
