import 'package:cuidapet32/app/core/database/sqlite_connection_factory.dart';
import 'package:cuidapet32/app/core/local_storage/flutter_secure_storage/flutter_secure_storage_local_impl.dart';
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:cuidapet32/app/core/local_storage/sherad_preferences/sherad_preferences_local_storage_impl.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/logger/logger_app_logger_impl.dart';
import 'package:cuidapet32/app/core/rest_client/dio/dio_rest_client.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client.dart';
import 'package:cuidapet32/app/repositories/address/address_repository.dart';
import 'package:cuidapet32/app/repositories/address/address_repository_impl.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:cuidapet32/app/services/address/address_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/core/auth/auth_store.dart';


class CoreMudule extends Module {

   @override
   void exportedBinds(Injector i) {
    i.addLazySingleton(SqliteConnectionFactory.new);
    i.addLazySingleton(AuthStore.new);    
    i.addLazySingleton<AppLogger>(LoggerAppLoggerImpl.new);
    i.addLazySingleton<LocalStorage>(SheradPreferencesLocalStorageImpl.new);
    i.addLazySingleton<LocalSecureStorage>(FlutterSecureStorageLocalImpl.new);
    i.addLazySingleton<RestClient>(DioRestClient.new);
    i.addLazySingleton<AddressRepository>(AddressRepositoryImpl.new);
    i.addLazySingleton<AddressService>(AddressServiceImpl.new);
    
   }
   

}