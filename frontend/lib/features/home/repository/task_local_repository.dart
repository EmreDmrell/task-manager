import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'ALTER TABLE $tableName ADD COLUMN isDeleted INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
      onCreate: (db, version) {
        return db.execute('''
            CREATE TABLE $tableName(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              uid TEXT NOT NULL,
              dueAt TEXT NOT NULL,
              hexColor TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              isSynced INTEGER NOT NULL,
              isDeleted INTEGER NOT NULL DEFAULT 0
            )
      ''');
      },
    );
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
    await db.insert(tableName, task.toMap());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks({required String uid}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isDeleted = ? AND uid = ?',
      whereArgs: [0, uid],
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TaskModel.fromMap(maps[i]);
      });
    }
    return [];
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isSynced = ? AND isDeleted = ?',
      whereArgs: [0, 0],
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TaskModel.fromMap(maps[i]);
      });
    }
    return [];
  }

  Future<List<TaskModel>> getUnsyncedDeletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isSynced =? AND isDeleted = ?',
      whereArgs: [0, 1],
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TaskModel.fromMap(maps[i]);
      });
    }
    return [];
  }

  Future<TaskModel?> getTaskById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateRowValue(String id, int newValue) async {
    final db = await database;
    final result = await db.update(
      tableName,
      {'isSynced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result == 0) {
      throw Exception('Failed to update the row');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // Soft delete, when there is no internet connection
  Future<void> softDeleteTask(String taskId) async {
    final db = await database;
    await db.update(
      tableName,
      {
        'isDeleted': 1,
        'isSynced': 0,
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
