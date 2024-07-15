import 'package:cuidapet_api/application/config/database_connection_configuration.dart';
import 'package:cuidapet_api/application/config/service_locator_config.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/application/routers/router_configure.dart';
import 'package:dotenv/dotenv.dart' show env, load;
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

import '../logger/logger.dart';

class ApplicationConfig {
  Future<void> loadConfigApplicaton(Router router) async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
    _loadRouterConfigure(router);
  }

  Future<void> _loadEnv() async => load();
  
  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['databaseHost']!, 
      user: env['DATABASE_USER'] ?? env['databaseUser']!, 
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!, 
      database: env['DATABASE_NAME'] ?? env['databaseName']!, 
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0);
      GetIt.I.registerSingleton(databaseConfig);
  }
  
  void _configLogger() => 
    GetIt.I.registerLazySingleton<ILogger>(() => Logger());
    
  void _loadDependencies() => configureDependencies();

  void _loadRouterConfigure(Router router) => RouterConfigure(router).configure();
}
