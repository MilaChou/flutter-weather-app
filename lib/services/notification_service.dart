import 'dart:math';
import 'session_service.dart';

class NotificationService {
  static Future<void> sendWeatherAlert(String fromUserId, String fromUserName, String cityName) async {
    final notification = {
      'id': 'notif_' + DateTime.now().millisecondsSinceEpoch.toString() + '_' + _randomString(4),
      'title': 'Запрос на добавление города',
      'message': 'Пользователь ' + fromUserName + ' просит добавить город ' + cityName + ' в список',
      'type': 'city_request',
      'fromUserId': fromUserId,
      'toUserId': 'admin_001',
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
      'data': {
        'userName': fromUserName,
        'cityName': cityName,
        'requestType': 'add_city',
      },
    };

    await SessionService.addNotification(notification);
  }

  static Future<void> sendUserBlockedNotification(String blockedUserName) async {
    final notification = {
      'id': 'notif_' + DateTime.now().millisecondsSinceEpoch.toString() + '_' + _randomString(4),
      'title': 'Пользователь заблокирован',
      'message': 'Администратор заблокировал пользователя ' + blockedUserName,
      'type': 'user_blocked',
      'fromUserId': 'admin_001',
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
      'data': {
        'blockedUser': blockedUserName,
      },
    };

    await SessionService.addNotification(notification);
  }

  static Future<void> markAsRead(String notificationId) async {
    await SessionService.markNotificationRead(notificationId);
  }

  static int getUnreadCount() {
    return SessionService.getUnreadCount();
  }

  static List<Map<String, dynamic>> getAllNotifications() {
    return SessionService.getNotificationsRaw();
  }

  static String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rand.nextInt(chars.length)))
    );
  }
}
