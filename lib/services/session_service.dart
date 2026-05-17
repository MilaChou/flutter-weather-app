import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SessionService {
  static const String _currentUserKey = 'current_user';
  static const String _blockedUsersKey = 'blocked_users';
  static const String _favoritesKey = 'favorites';
  static const String _notificationsKey = 'notifications';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Current User Session
  static Future<void> saveCurrentUser(User user) async {
    await _prefs?.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  static User? getCurrentUser() {
    final data = _prefs?.getString(_currentUserKey);
    if (data == null) return null;
    return User.fromJson(jsonDecode(data));
  }

  static Future<void> clearCurrentUser() async {
    await _prefs?.remove(_currentUserKey);
  }

  // Blocked Users (Admin)
  static Future<void> addBlockedUser(String userId) async {
    final blocked = getBlockedUsers();
    if (!blocked.contains(userId)) {
      blocked.add(userId);
      await _prefs?.setStringList(_blockedUsersKey, blocked);
    }
  }

  static Future<void> removeBlockedUser(String userId) async {
    final blocked = getBlockedUsers();
    blocked.remove(userId);
    await _prefs?.setStringList(_blockedUsersKey, blocked);
  }

  static List<String> getBlockedUsers() {
    return _prefs?.getStringList(_blockedUsersKey) ?? [];
  }

  static bool isUserBlocked(String userId) {
    return getBlockedUsers().contains(userId);
  }

  // Favorites (Client)
  static Future<void> addFavorite(String cityName) async {
    final favorites = getFavorites();
    if (!favorites.contains(cityName)) {
      favorites.add(cityName);
      await _prefs?.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFavorite(String cityName) async {
    final favorites = getFavorites();
    favorites.remove(cityName);
    await _prefs?.setStringList(_favoritesKey, favorites);
  }

  static List<String> getFavorites() {
    return _prefs?.getStringList(_favoritesKey) ?? [];
  }

  static bool isFavorite(String cityName) {
    return getFavorites().contains(cityName);
  }

  // Notifications
  static Future<void> addNotification(Map<String, dynamic> notification) async {
    final notifications = getNotificationsRaw();
    notifications.add(notification);
    await _prefs?.setString(_notificationsKey, jsonEncode(notifications));
  }

  static List<Map<String, dynamic>> getNotificationsRaw() {
    final data = _prefs?.getString(_notificationsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.cast<Map<String, dynamic>>();
  }

  static Future<void> markNotificationRead(String id) async {
    final notifications = getNotificationsRaw();
    for (var n in notifications) {
      if (n['id'] == id) {
        n['isRead'] = true;
      }
    }
    await _prefs?.setString(_notificationsKey, jsonEncode(notifications));
  }

  static int getUnreadCount() {
    return getNotificationsRaw().where((n) => !(n['isRead'] ?? false)).length;
  }

  static Future<void> clearAllData() async {
    await _prefs?.clear();
  }
}
