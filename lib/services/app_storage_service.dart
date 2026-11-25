import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/car_lot_model.dart';

class AppStorageService {
  static const String _storageFileName = 'carfinder_preferences.json';
  static const MethodChannel _bridgeChannel = MethodChannel('carfinder/native_bridge');
  static Map<String, dynamic>? _cachedStorageMap;

  static Future<Map<String, dynamic>> _readStorageMap() async {
    if (_cachedStorageMap != null) {
      return Map<String, dynamic>.from(_cachedStorageMap!);
    }
    try {
      final nativePayload = await _bridgeChannel.invokeMethod<String>('readStoragePayload');
      if (nativePayload != null && nativePayload.trim().isNotEmpty && nativePayload != '{}') {
        final parsedMap = jsonDecode(nativePayload) as Map<String, dynamic>;
        _cachedStorageMap = parsedMap;
        return Map<String, dynamic>.from(parsedMap);
      }
    } catch (_) {}

    try {
      final storageFile = File(_storageFileName);
      if (await storageFile.exists()) {
        final rawContent = await storageFile.readAsString();
        if (rawContent.trim().isNotEmpty) {
          final parsedMap = jsonDecode(rawContent) as Map<String, dynamic>;
          _cachedStorageMap = parsedMap;
          return Map<String, dynamic>.from(parsedMap);
        }
      }
    } catch (_) {}

    _cachedStorageMap = {};
    return {};
  }

  static Future<void> _writeStorageMap(Map<String, dynamic> storageMap) async {
    _cachedStorageMap = Map<String, dynamic>.from(storageMap);
    final rawContent = jsonEncode(storageMap);
    try {
      await _bridgeChannel.invokeMethod<bool>('saveStoragePayload', {
        'json': rawContent,
      });
    } catch (_) {}
    try {
      final storageFile = File(_storageFileName);
      await storageFile.writeAsString(rawContent);
    } catch (_) {}
  }

  static Future<void> saveUserProfile({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? city,
  }) async {
    final storageMap = await _readStorageMap();
    storageMap['name'] = name;
    storageMap['email'] = email;
    storageMap['password'] = password;
    storageMap['last_active_timestamp'] = DateTime.now().millisecondsSinceEpoch;
    storageMap.remove('exit_timestamp');
    if (phone != null) storageMap['phone'] = phone;
    if (city != null) storageMap['city'] = city;
    await _writeStorageMap(storageMap);
  }

  static Future<void> recordExitTimestamp() async {
    final storageMap = await _readStorageMap();
    storageMap['exit_timestamp'] = DateTime.now().millisecondsSinceEpoch;
    await _writeStorageMap(storageMap);
  }

  static Future<void> clearExitTimestamp() async {
    final storageMap = await _readStorageMap();
    storageMap.remove('exit_timestamp');
    await _writeStorageMap(storageMap);
  }

  static Future<bool> isSessionActive() async {
    final storageMap = await _readStorageMap();
    final profileName = (storageMap['name'] as String?) ?? '';
    if (profileName.isEmpty) return false;

    final exitTime = storageMap['exit_timestamp'] as int?;
    if (exitTime != null) {
      final elapsedSinceExit = DateTime.now().millisecondsSinceEpoch - exitTime;
      if (elapsedSinceExit > 60000) {
        return false;
      }
    }
    return true;
  }

  static Future<Map<String, String>> loadUserProfile() async {
    final storageMap = await _readStorageMap();
    return {
      'name': (storageMap['name'] as String?) ?? '',
      'email': (storageMap['email'] as String?) ?? '',
      'password': (storageMap['password'] as String?) ?? '',
      'phone': (storageMap['phone'] as String?) ?? '',
      'city': (storageMap['city'] as String?) ?? '',
    };
  }

  static Future<void> clearUserProfile() async {
    final storageMap = await _readStorageMap();
    storageMap.remove('name');
    storageMap.remove('email');
    storageMap.remove('password');
    storageMap.remove('phone');
    storageMap.remove('city');
    storageMap.remove('login_timestamp');
    storageMap.remove('last_active_timestamp');
    storageMap.remove('exit_timestamp');
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
    return ['101', '102', '103'];
  }

  static Future<List<Map<String, String>>> loadNotificationsList() async {
    final storageMap = await _readStorageMap();
    final cleared = storageMap['notifications_cleared'] as bool? ?? false;
    if (cleared) return [];

    return [
      {
        'tag': 'IAAI',
        'title': 'Знизилася нова ціна на авто:',
        'subtitle': 'Tesla Model X 2019-2020 й інші 2',
      },
      {
        'tag': 'COPART',
        'title': 'Змінилася ціна авто!',
        'subtitle': 'Tesla Model 3 2018\nСтара ціна: 9,825\nНова ціна: 11,225',
      },
    ];
  }

  static Future<void> clearNotificationsList() async {
    final storageMap = await _readStorageMap();
    storageMap['notifications_cleared'] = true;
    await _writeStorageMap(storageMap);
  }

  static Future<List<Map<String, String>>> loadSearchQueriesList() async {
    final storageMap = await _readStorageMap();
    final rawList = storageMap['search_queries'] as List<dynamic>?;
    if (rawList != null) {
      return rawList.map((queryItem) => Map<String, String>.from(queryItem as Map)).toList();
    }
    return [
      {
        'title': 'Tesla Model 3 (2014-2025)',
        'auction': 'COPART',
        'criteria': 'Make: TESLA | Year: 2014-2025 | Sedan',
      },
      {
        'title': 'Tesla Model X (2019-2022)',
        'auction': 'IAAI',
        'criteria': 'Make: TESLA | Year: 2019-2022 | SUV',
      },
      {
        'title': 'BMW M3 Competition (2020-2024)',
        'auction': 'COPART',
        'criteria': 'Make: BMW | Model: M3 | Run & Drive',
      },
    ];
  }

  static Future<void> saveSearchQueriesList(List<Map<String, String>> queries) async {
    final storageMap = await _readStorageMap();
    storageMap['search_queries'] = queries;
    await _writeStorageMap(storageMap);
  }

  static Future<void> saveThemeMode(bool isDark) async {
    final storageMap = await _readStorageMap();
    storageMap['is_dark_theme'] = isDark;
    await _writeStorageMap(storageMap);
  }

  static Future<bool> loadThemeMode() async {
    final storageMap = await _readStorageMap();
    return (storageMap['is_dark_theme'] as bool?) ?? true;
  }

  static Future<void> saveNotificationSettings({
    required bool searchAlerts,
    required bool savedCarAlerts,
  }) async {
    final storageMap = await _readStorageMap();
    storageMap['notifications_search_alerts'] = searchAlerts;
    storageMap['notifications_saved_car_alerts'] = savedCarAlerts;
    await _writeStorageMap(storageMap);
  }

  static Future<Map<String, bool>> loadNotificationSettings() async {
    final storageMap = await _readStorageMap();
    return {
      'search': (storageMap['notifications_search_alerts'] as bool?) ?? true,
      'saved_cars': (storageMap['notifications_saved_car_alerts'] as bool?) ?? true,
    };
  }

  static Future<List<CarLotModel>> loadCarLotsList() async {
    final storageMap = await _readStorageMap();
    final rawLotsList = storageMap['car_lots'] as List<dynamic>?;
    if (rawLotsList != null && rawLotsList.isNotEmpty) {
      return rawLotsList
          .map((lotItem) => CarLotModel.fromJson(lotItem as Map<String, dynamic>))
          .toList();
    }
    return [
      CarLotModel(
        id: 101,
        title: 'Tesla Model X 2020',
        price: 12323,
        isFavorite: true,
        status: LotStatus.active,
        auction: 'IAAI',
      ),
      CarLotModel(
        id: 102,
        title: 'Tesla Model 3 2019',
        price: 7995,
        isFavorite: true,
        status: LotStatus.active,
        auction: 'Copart',
      ),
      CarLotModel(
        id: 103,
        title: '2021 Tesla Model 3',
        price: 8100,
        isFavorite: true,
        status: LotStatus.active,
        auction: 'Copart',
      ),
      CarLotModel(
        id: 104,
        title: 'BMW M3 Competition G80',
        price: 18500,
        isFavorite: false,
        status: LotStatus.active,
        auction: 'IAAI',
      ),
      CarLotModel(
        id: 105,
        title: 'Audi RS6 Avant Quattro',
        price: 24000,
        isFavorite: false,
        status: LotStatus.sold,
        auction: 'Copart',
      ),
    ];
  }

  static Future<void> saveCarLotsList(List<CarLotModel> carLots) async {
    final storageMap = await _readStorageMap();
    storageMap['car_lots'] = carLots.map((lot) => lot.toJson()).toList();
    await _writeStorageMap(storageMap);
  }
}
