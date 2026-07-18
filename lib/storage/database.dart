import 'package:scanwise/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_users.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            firstname TEXT,
            lastname TEXT,
            profilePath TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> signup({
    required String email,
    required String firstName,
    required String lastName,
    required String profilePath,
    required String password,
  }) async {
    final db = await database;

    return db.insert(
      'users',
      {
        'email': email,
        'firstname': firstName,
        'Lastname': lastName,
        'profilePath': profilePath,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromJson(result.first);
  }
}
