import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  Database? _instance;

  static final UserDatabase _database = UserDatabase._internal();

  UserDatabase._internal();

  factory UserDatabase() {
    return _database;
  }

  Future<Database> getInstance() async {
    if (_instance == null) {
      _instance = await _openUserDatabase();
    }

    return _instance!;
  }

  Future<Database> _openUserDatabase() async {
    final pathDatabase = await getDatabasesPath();
    final nameDatabase = 'form_users.db';
    final database = await openDatabase(
      join(pathDatabase, nameDatabase),
      version: 1,
      onCreate: (db, version) async {
        print('versão $version');

        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            cep TEXT,
            address TEXT,
            file_path TEXT
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print('oldVersion: $oldVersion');
        print('newVersion: $newVersion');
      },
    );

    return database;
  }
}
