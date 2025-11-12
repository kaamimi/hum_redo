import './models/memory.dart';
import './database_helper.dart';
import '/core/services/image_handler.dart';

class MemoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ImageHandler _imageHandler = ImageHandler();

  // Create
  Future<void> createMemory(Memory memory) async {
    await _dbHelper.insertMemory(memory);
  }

  // Read all
  Future<List<Memory>> getAllMemories() async {
    return await _dbHelper.getAllMemories();
  }

  // Read by ID
  Future<Memory?> getMemoryById(String id) async {
    return await _dbHelper.getMemoryById(id);
  }

  // Update
  Future<void> updateMemory(Memory memory) async {
    await _dbHelper.updateMemory(memory);
  }

  // Delete
  Future<void> deleteMemory(String id) async {
    final memory = await _dbHelper.getMemoryById(id);
    if (memory?.imageUrl != null) {
      await _imageHandler.deleteImage(memory!.imageUrl!);
    }
    await _dbHelper.deleteMemory(id);
  }

  // Delete all
  Future<void> deleteAllMemories() async {
    await _dbHelper.deleteAllMemories();
  }
}
