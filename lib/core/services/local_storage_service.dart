import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic methods for storing and retrieving data
  Future<void> storeData(String key, dynamic data) async {
    if (data is String) {
      await _prefs.setString(key, data);
    } else if (data is int) {
      await _prefs.setInt(key, data);
    } else if (data is double) {
      await _prefs.setDouble(key, data);
    } else if (data is bool) {
      await _prefs.setBool(key, data);
    } else if (data is List<String>) {
      await _prefs.setStringList(key, data);
    } else {
      // For complex objects, convert to JSON
      await _prefs.setString(key, jsonEncode(data));
    }
  }

  T? getData<T>(String key) {
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == List<String>) {
      return _prefs.getStringList(key) as T?;
    } else {
      // For complex objects, decode from JSON
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as T?;
      }
      return null;
    }
  }

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Specific methods for app data
  Future<void> storeGames(List<Map<String, dynamic>> games) async {
    await storeData('cached_games', games);
    await storeData('games_cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  List<Map<String, dynamic>>? getCachedGames() {
    return getData<List<Map<String, dynamic>>>('cached_games');
  }

  DateTime? getGamesCacheTimestamp() {
    final timestamp = getData<int>('games_cache_timestamp');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> storeAnnouncements(List<Map<String, dynamic>> announcements) async {
    await storeData('cached_announcements', announcements);
    await storeData('announcements_cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  List<Map<String, dynamic>>? getCachedAnnouncements() {
    return getData<List<Map<String, dynamic>>>('cached_announcements');
  }

  DateTime? getAnnouncementsCacheTimestamp() {
    final timestamp = getData<int>('announcements_cache_timestamp');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> storeUserProfile(Map<String, dynamic> profile) async {
    await storeData('cached_user_profile', profile);
    await storeData('profile_cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic>? getCachedUserProfile() {
    return getData<Map<String, dynamic>>('cached_user_profile');
  }

  DateTime? getProfileCacheTimestamp() {
    final timestamp = getData<int>('profile_cache_timestamp');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> storeStatistics(Map<String, dynamic> statistics) async {
    await storeData('cached_statistics', statistics);
    await storeData('statistics_cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic>? getCachedStatistics() {
    return getData<Map<String, dynamic>>('cached_statistics');
  }

  DateTime? getStatisticsCacheTimestamp() {
    final timestamp = getData<int>('statistics_cache_timestamp');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // Offline queue for pending operations
  Future<void> addToOfflineQueue(String operation, Map<String, dynamic> data) async {
    final queue = getData<List<Map<String, dynamic>>>('offline_queue') ?? [];
    queue.add({
      'operation': operation,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await storeData('offline_queue', queue);
  }

  List<Map<String, dynamic>> getOfflineQueue() {
    return getData<List<Map<String, dynamic>>>('offline_queue') ?? [];
  }

  Future<void> clearOfflineQueue() async {
    await removeData('offline_queue');
  }

  // Check if cache is still valid
  bool isCacheValid(DateTime? cacheTimestamp, {Duration maxAge = const Duration(minutes: 15)}) {
    if (cacheTimestamp == null) return false;
    return DateTime.now().difference(cacheTimestamp) < maxAge;
  }

  // Network status
  Future<void> setNetworkStatus(bool isOnline) async {
    await storeData('is_online', isOnline);
    await storeData('last_network_check', DateTime.now().millisecondsSinceEpoch);
  }

  bool getNetworkStatus() {
    return getData<bool>('is_online') ?? false;
  }

  DateTime? getLastNetworkCheck() {
    final timestamp = getData<int>('last_network_check');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
} 