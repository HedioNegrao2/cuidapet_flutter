
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SheradPreferencesLocalStorageImpl implements LocalStorage {

  Future<SharedPreferences> get _instace => SharedPreferences.getInstance();


  @override
  Future<void> clear() async {
    final sharedPreferences = await _instace;
    sharedPreferences.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final sharedPreferences = await _instace;
    return sharedPreferences.containsKey(key);
  }

  @override
  Future<V> read<V>(String key) async {
    final sharedPreferences = await _instace;
    return sharedPreferences.get(key) as V;
  }

  @override
  Future<void> remove(String key) async {
    final sharedPreferences = await _instace;
    sharedPreferences.remove(key);
  }

  @override
  Future<void> write<V>(String key, V value) async{
    final sharedPreferences = await _instace;
    if(value is int) {
      sharedPreferences.setInt(key, value);
    } else if(value is double) {
      sharedPreferences.setDouble(key, value);
    } else if(value is String) {
      sharedPreferences.setString(key, value);
    } else if(value is bool) {
      sharedPreferences.setBool(key, value);
    } else if(value is List<String>) {
      sharedPreferences.setStringList(key, value);
    } else {
      throw Exception('Type not supported');
    }


  }
  
}