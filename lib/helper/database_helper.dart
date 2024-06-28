import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/home/models/home_list_model.dart';



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'repositories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE repositories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, full_name TEXT, html_url TEXT, description TEXT, stargazers_count INTEGER)',
        );
      },
    );
  }

  Future<void> insertRepositories(List<Repository> repositories) async {
    final db = await database;
    Batch batch = db.batch();
    repositories.forEach((repo) {
      batch.insert('repositories', repo.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
  }

  Future<List<Repository>> getRepositories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('repositories');
    print("get repositories works");
    return List.generate(maps.length, (i) {
      return Repository.fromJson(maps[i]);
    });
  }
}
