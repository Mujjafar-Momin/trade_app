import 'package:get_storage/get_storage.dart';

/// [AppStorage]
/// Local storage for the app. This is a singleton class that can be accessed from anywhere in the app.
/// It can be used to store and retrieve data from local storage, such as shared preferences or a local database.
class AppStorage {
  AppStorage._();

  static final _storage = GetStorage('trade_app');
  static bool _initialized = false;

  /// Initialize GetStorage
  static Future<void> init() async {
    if (_initialized) return;
    await GetStorage.init('trade_app');
    _initialized = true;
  }

  /// Write value to storage
  static Future<void> write(AppStorageKeys key, dynamic value, {String suffix = ''}) async {
    await _storage.write(key.value + suffix, value);
  }

  /// Read value from storage
  static T? read<T>(AppStorageKeys key, {T? defaultValue, String suffix = ''}) {
    return _storage.read<T>(key.value + suffix) ?? defaultValue;
  }

  /// Remove value from storage
  static Future<void> remove(AppStorageKeys key) async {
    await _storage.remove(key.value);
  }

  static Future<void> removeWithSuffix(AppStorageKeys key, {String suffix = ''}) async {
    await _storage.remove(key.value + suffix);
  }

  /// Check if a key exists
  static bool hasKey(AppStorageKeys key) {
    return _storage.hasData(key.value);
  }

  /// Clear all storage
  static Future<void> clearAll() async {
    await _storage.erase();
  }
}

/// [AppStorageKeys]
/// This class defines the keys used for storing data in local storage.
/// By centralizing these keys in one place, it helps to avoid typos and
/// makes it easier to manage the storage of data across the application.
class AppStorageKeys {
  final String value;

  const AppStorageKeys._(this.value);

  static const storage = AppStorageKeys._('storage');
  static const wallet = AppStorageKeys._('wallet');
  static const holdings = AppStorageKeys._('holdings');

}
