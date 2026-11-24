import 'dart:convert';
import 'dart:io';

class AppStorageService {
  static const String _storageFileName = 'carfinder_preferences.json';

  static Future<Map<String, dynamic>> _readStorageMap() async {
    try {
      final storageFile = File(_storageFileName);
      if (await storageFile.exists()) {
        final rawContent = await storageFile.readAsString();
        if (rawContent.trim().isNotEmpty) {
          return jsonDecode(rawContent) as Map<String, dynamic>;
        }
      }
    } catch (_) {}
    return {};
  }

  static Future<void> _writeStorageMap(Map<String, dynamic> storageMap) async {
    try {
      final storageFile = File(_storageFileName);
      final rawContent = jsonEncode(storageMap);
      await storageFile.writeAsString(rawContent);
    } catch (_) {}
  }

  static Future<void> saveUserProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    final storageMap = await _readStorageMap();
    storageMap['name'] = name;
    storageMap['email'] = email;
    storageMap['password'] = password;
    await _writeStorageMap(storageMap);
  }

  static Future<Map<String, String>> loadUserProfile() async {
    final storageMap = await _readStorageMap();
    return {
      'name': (storageMap['name'] as String?) ?? '',
      'email': (storageMap['email'] as String?) ?? '',
      'password': (storageMap['password'] as String?) ?? '',
    };
  }

  static Future<void> clearUserProfile() async {
    final storageMap = await _readStorageMap();
    storageMap.remove('name');
    storageMap.remove('email');
    storageMap.remove('password');
    await _writeStorageMap(storageMap);
  }

  static Future<void> saveFavoriteIdentities(List<String> favoriteIdentities) async {
    final storageMap = await _readStorageMap();
    storageMap['favorite_ids'] = favoriteIdentities;
    await _writeStorageMap(storageMap);
  }

  static Future<List<String>> loadFavoriteIdentities() async {
    final storageMap = await _readStorageMap();
    final rawList = storageMap['favorite_ids'] as List<dynamic>?;
    if (rawList != null) {
      return rawList.map((item) => item.toString()).toList();
    }
    return [];
  }
}
