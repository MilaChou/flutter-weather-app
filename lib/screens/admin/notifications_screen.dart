import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../utils/helpers.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = NotificationService.getAllNotifications();
    });
  }

  Future<void> _markAsRead(String id) async {
    await NotificationService.markAsRead(id);
    _loadNotifications();
  }

  Future<void> _markAllAsRead() async {
    for (final notification in _notifications) {
      if (!(notification['isRead'] ?? false)) {
        await NotificationService.markAsRead(notification['id']);
      }
    }
    _loadNotifications();
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'city_request':
        return Icons.location_city;
      case 'user_blocked':
        return Icons.block;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'city_request':
        return Colors.blue;
      case 'user_blocked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !(n['isRead'] ?? false)).length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      appBar: AppBar(
        title: const Text(
          'Уведомления',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all, color: Colors.white),
              label: const Text(
                'Все прочитано',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 80, color: Colors.white54),
                  const SizedBox(height: 16),
                  Text(
                    'Нет уведомлений',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final isRead = notification['isRead'] ?? false;
                final type = notification['type'] ?? 'system';

                return Dismissible(
                  key: Key(notification['id']),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  onDismissed: (_) => _markAsRead(notification['id']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isRead ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isRead
                            ? Colors.transparent
                            : _getColorForType(type).withOpacity(0.5),
                        width: isRead ? 0 : 2,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColorForType(type).withOpacity(0.2),
                        child: Icon(
                          _getIconForType(type),
                          color: _getColorForType(type),
                        ),
                      ),
                      title: Text(
                        notification['title'] ?? 'Уведомление',
                        style: TextStyle(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['message'] ?? '',
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Helpers.formatDate(DateTime.parse(notification['createdAt'])),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      trailing: isRead
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                      onTap: () => _markAsRead(notification['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
