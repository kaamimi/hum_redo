import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '/core/services/image_handler.dart';
import '/core/data/repository.dart';
import '/core/data/models/memory.dart';

final imageHandlerProvider = Provider<ImageHandler>((ref) => ImageHandler());

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepository();
});

class NewMemoryState {
  final File? pickedImage;
  final String note;
  final DateTime selectedDate;
  final bool isLoading;
  final String? error;

  NewMemoryState({
    this.pickedImage,
    this.note = '',
    DateTime? selectedDate,
    this.isLoading = false,
    this.error,
  }) : selectedDate = selectedDate ?? DateTime.now();

  bool get hasContent => pickedImage != null || note.trim().isNotEmpty;

  NewMemoryState copyWith({
    File? pickedImage,
    String? note,
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
    bool clearImage = false,
  }) {
    return NewMemoryState(
      pickedImage: clearImage ? null : pickedImage ?? this.pickedImage,
      note: note ?? this.note,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NewMemoryViewModel extends Notifier<NewMemoryState> {
  @override
  NewMemoryState build() {
    return NewMemoryState();
  }

  ImageHandler get _imageHandler => ref.read(imageHandlerProvider);
  MemoryRepository get _repository => ref.read(memoryRepositoryProvider);

  void updateNote(String note) {
    state = state.copyWith(note: note);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  Future<void> pickImage() async {
    try {
      final image = await _imageHandler.pickFromGallery();
      if (image != null) {
        state = state.copyWith(pickedImage: image);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  void removeImage() {
    state = state.copyWith(clearImage: true);
  }

  Future<bool> saveMemory() async {
    if (!state.hasContent) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      String? savedImagePath;
      if (state.pickedImage != null) {
        savedImagePath = await _imageHandler.saveImageToAppDirectory(
          state.pickedImage!,
        );
      }

      const uuid = Uuid();
      final memory = Memory(
        id: uuid.v4(),
        createdAt: state.selectedDate,
        note: state.note.trim().isNotEmpty ? state.note.trim() : null,
        imageUrl: savedImagePath,
      );

      await _repository.createMemory(memory);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save memory: $e',
      );
      return false;
    }
  }
}

final newMemoryViewModelProvider =
    NotifierProvider.autoDispose<NewMemoryViewModel, NewMemoryState>(
      NewMemoryViewModel.new,
    );
