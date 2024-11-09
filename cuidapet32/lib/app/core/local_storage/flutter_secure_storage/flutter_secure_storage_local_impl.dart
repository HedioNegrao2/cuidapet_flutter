
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageLocalImpl implements LocalSecureStorage {
  FlutterSecureStorage get _intance => const FlutterSecureStorage();

  
  @override
  Future<void> clear() => _intance.deleteAll();   
  

  @override
  Future<bool> containsKey(String key) => _intance.containsKey(key: key);

  @override
  Future<String?> read(String key) => _intance.read(key: key);

  @override
  Future<void> remove(String key)  => _intance.delete(key: key);

  @override
  Future<void> write(String key, String value)  => _intance.write(key: key, value: value);
  
}