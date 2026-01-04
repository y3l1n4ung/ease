import 'package:shared_preferences/shared_preferences.dart';

/// Global storage service initialized before app starts
class StorageService {
  static SharedPreferences? _prefs;

  static void initialize(SharedPreferences prefs) {
    _prefs = prefs;
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw StateError(
        'StorageService not initialized. Call StorageService.initialize() in main()',
      );
    }
    return _prefs!;
  }

  // Auth keys
  static const authTokenKey = 'auth_token';
  static const authUserKey = 'auth_user';

  // Convenience methods
  static String? getString(String key) => instance.getString(key);
  static Future<bool> setString(String key, String value) =>
      instance.setString(key, value);
  static Future<bool> remove(String key) => instance.remove(key);
}
