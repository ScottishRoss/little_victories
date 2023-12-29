import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> insert(String key, String value) async {
    log('Inserting $key with value $value... Checking if it exists already');
    final String? _doesKeyExist = await getFromKey(key);
    if (_doesKeyExist == null) {
      log('Key does not exist, inserting...');
      try {
        await storage.write(key: key, value: value);
        log('Inserted $key with value $value');
        return true;
      } catch (e) {
        log(e.toString());
        return false;
      }
    } else {
      log('Key already exists, deleting and inserting...');
      deleteFromKey(key);
      log('Deleted $key, inserting...');
      try {
        await storage.write(key: key, value: value);
        log('Inserted $key with value $value');
        return true;
      } catch (e) {
        log(e.toString());
        return false;
      }
    }
  }

  Future<String?> getFromKey(String key) async {
    // This allows us to be able to fetch secure values while the app is backgrounded,
    // by specifying first_unlock or first_unlock_this_device. The default if not specified is unlocked.
    const IOSOptions options =
        IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    try {
      final String? value = await storage.read(key: key, iOptions: options);
      return value;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Map<String, String>?> getAll() async {
    try {
      final Map<String, String> value = await storage.readAll();
      return value;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> deleteFromKey(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> deleteAll() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      return false;
    }
    return true;
  }
}
