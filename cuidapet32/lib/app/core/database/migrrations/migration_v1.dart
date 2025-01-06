
import 'package:cuidapet32/app/core/database/migrrations/migraion.dart';
import 'package:sqflite/sqflite.dart';

class MigrationV1 extends Migraion {
  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE IF NOT EXISTS address (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address TEXT not null,
        lat text,
        lng text,
        additional text      
        )
    ''');
  }

  @override
  void update(Batch batch) {
    
  }
 
}