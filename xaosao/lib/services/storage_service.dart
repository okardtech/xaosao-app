import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  T? read<T>(String key) {
    final value = _prefs.get(key);
    if (value is T) return value;
    return null;
  }

  Future<void> write(String key, dynamic value) async {
    if (value is String) await _prefs.setString(key, value);
    else if (value is int) await _prefs.setInt(key, value);
    else if (value is bool) await _prefs.setBool(key, value);
    else if (value is double) await _prefs.setDouble(key, value);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}