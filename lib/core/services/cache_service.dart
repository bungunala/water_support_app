import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> save(String key, dynamic data);
  Future<dynamic> get(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> hasKey(String key);
  Future<DateTime?> getTimestamp(String key);
  Future<bool> isExpired(String key, Duration maxAge);
}

class CacheServiceImpl implements CacheService {
  static const String _timestampPrefix = '_timestamp_';

  @override
  Future<void> save(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
    await prefs.setString('$key$_timestampPrefix', DateTime.now().toIso8601String());
  }

  @override
  Future<dynamic> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.remove('$key$_timestampPrefix');
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<bool> hasKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  @override
  Future<DateTime?> getTimestamp(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final timestampStr = prefs.getString('$key$_timestampPrefix');
    if (timestampStr == null) return null;
    return DateTime.parse(timestampStr);
  }

  @override
  Future<bool> isExpired(String key, Duration maxAge) async {
    final timestamp = await getTimestamp(key);
    if (timestamp == null) return true;
    return DateTime.now().difference(timestamp) > maxAge;
  }
}
