import 'package:cuidapet_api/application/config/database_connection_configuration.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:dotenv/dotenv.dart' show env, load;
import 'package:get_it/get_it.dart';

import '../logger/logger.dart';

class ApplicationConfig {
  Future<void> loadConfigApplicaton() async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
  }

  Future<void> _loadEnv() async => load();
  
  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['databaseHost'] ?? '', 
      user: env['DATABASE_USER'] ?? env['databaseUser'] ?? '', 
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword'] ?? '', 
      database: env['DATABASE_NAME'] ?? env['databasenName'] ?? '', 
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0
      );
      GetIt.I.registerSingleton(databaseConfig);
  }
  
  void _configLogger() => 
    GetIt.I.registerLazySingleton<ILogger>(() => Logger());
}
