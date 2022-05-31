import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> insertIntoSecureStorage(String key, String value) async {
    final String? _doesKeyExist = await getFromSecureStorage(key);
    if (_doesKeyExist == null) {
      try {
        await storage.write(key: key, value: value);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      deleteFromSecureStorage(key);
      try {
        await storage.write(key: key, value: value);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  Future<String?> getFromSecureStorage(String key) async {
    // This allows us to be able to fetch secure values while the app is backgrounded,
    // by specifying first_unlock or first_unlock_this_device. The default if not specified is unlocked.
    const IOSOptions options = IOSOptions(
      accessibility: IOSAccessibility.first_unlock,
    );
    try {
      final String? value = await storage.read(key: key, iOptions: options);
      return value;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> deleteFromSecureStorage(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> deleteAllFromSecureStorage() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      return false;
    }
    return true;
  }
}
