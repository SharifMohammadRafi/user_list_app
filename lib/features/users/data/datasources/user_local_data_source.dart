import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  static const _cacheKey = 'users_cache_all';
  static const _cacheTimestampKey = 'users_cache_timestamp';

  static const Duration cacheTtl = Duration(hours: 1);

  Future<void> cacheUsers(List<Map<String, dynamic>> rawUsers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(rawUsers));
    await prefs.setString(_cacheTimestampKey, DateTime.now().toIso8601String());
  }

  Future<List<Map<String, dynamic>>?> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_cacheKey);
    if (str == null) return null;
    final list = jsonDecode(str) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  Future<DateTime?> getCacheTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getString(_cacheTimestampKey);
    if (ts == null) return null;
    return DateTime.tryParse(ts);
  }

  Future<bool> isCacheStale() async {
    final ts = await getCacheTimestamp();
    if (ts == null) return true;
    return DateTime.now().difference(ts) > cacheTtl;
  }
}
