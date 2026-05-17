import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../services/notification_service.dart';

class NotificationBadge extends StatefulWidget {
  final VoidCallback onTap;

  const NotificationBadge({Key? key, required this.onTap}) : super(key: key);

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _updateCount();
    // Auto-refresh every 3 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      _updateCount();
      return true;
    });
  }

  void _updateCount() {
    final count = NotificationService.getUnreadCount();
    if (count != _unreadCount) {
      setState(() {
        _unreadCount = count;
      });
      if (count > 0) {
        _controller.forward().then((_) => _controller.reverse());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.2),
          child: badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -12),
            showBadge: _unreadCount > 0,
            badgeContent: Text(
              '$_unreadCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(6),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications, size: 28),
              onPressed: () {
                widget.onTap();
                _updateCount();
              },
            ),
          ),
        );
      },
    );
  }
}
