
import 'package:cuidapet32/app/core/database/migrrations/migraion.dart';
import 'package:cuidapet32/app/core/database/migrrations/migration_v1.dart';

class SqliteMigrationFactory {
  List<Migraion> getCreateMigrations() => [
    MigrationV1(),
  ];

  List<Migraion> getUpdateMigrations(int verson) {
    return [];
  }   
  
  
}