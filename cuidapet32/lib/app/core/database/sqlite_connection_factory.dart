import 'package:cuidapet32/app/core/database/sqlite_migration_factory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class SqliteConnectionFactory {
  static const _version = 1;
  static const _databaseName = 'CUIDAPET_LOCAL_DB';
  static SqliteConnectionFactory? _instance;

  Database? _db;
  final _lock = Lock();

  Future<Database> openConnection() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          final databasesPath = await getDatabasesPath();
          final pathDatabase = join(databasesPath + _databaseName);
          _db = await openDatabase(pathDatabase,
              version: _version,
              onConfigure: _onConfigure,
              onCreate: _onCreate,
              onUpgrade: _onUpgrade);
        }
      });
    }

    return _db!;
  }

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    _instance ??= SqliteConnectionFactory._();
    return _instance!;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigrations();

    for (var migration in migrations) {
      migration.create(batch);
    }
    batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpdateMigrations(oldVersion);

    for (var migration in migrations) {
      migration.create(batch);
    }
    batch.commit();
  }

  void closeConnection() {
    _db?.close();
    _db = null;
  }
}
