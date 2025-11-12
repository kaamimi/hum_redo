import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import './models/memory.dart';

class DatabaseHelper {
  static const String dbName = 'hum_memories.db';
  static const String tableName = 'memories';
  static const int dbVersion = 1;

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, dbName),
      version: dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        note TEXT,
        imageUrl TEXT,
        voiceNoteUrl TEXT,
        audioUrl TEXT,
        audioSource TEXT,
        doodle TEXT,
        tags TEXT
      )
    ''');
  }

  // Create
  Future<void> insertMemory(Memory memory) async {
    final db = await database;
    await db.insert(
      tableName,
      memory.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read all
  Future<List<Memory>> getAllMemories() async {
    final db = await database;
    final maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Memory.fromJson(maps[i]));
  }

  // Read by ID
  Future<Memory?> getMemoryById(String id) async {
    final db = await database;
    final maps = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Memory.fromJson(maps.first);
    }
    return null;
  }

  // Update
  Future<void> updateMemory(Memory memory) async {
    final db = await database;
    await db.update(
      tableName,
      memory.toJson(),
      where: 'id = ?',
      whereArgs: [memory.id],
    );
  }

  // Delete
  Future<void> deleteMemory(String id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Delete all
  Future<void> deleteAllMemories() async {
    final db = await database;
    await db.delete(tableName);
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
