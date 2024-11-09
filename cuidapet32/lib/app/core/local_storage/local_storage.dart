abstract class LocalStorage {
  Future<void> write<V>(String key, V value);
  Future<V?> read<V>(String key);
  Future<bool> containsKey(String key);
  Future<void> clear();
  Future<void> remove(String key);

}

abstract class LocalSecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);  
  Future<bool> containsKey(String key);
  Future<void> clear();
  Future<void> remove(String key);

}