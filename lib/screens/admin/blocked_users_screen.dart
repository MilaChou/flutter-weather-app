import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../services/notification_service.dart';
import '../../models/user.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _users = AuthService.getAllUsers();
    });
  }

  Future<void> _toggleBlock(User user) async {
    if (user.isBlocked) {
      await AuthService.unblockUser(user.id);
      _showMessage('Пользователь ' + user.name + ' разблокирован');
    } else {
      await AuthService.blockUser(user.id);
      await NotificationService.sendUserBlockedNotification(user.name);
      _showMessage('Пользователь ' + user.name + ' заблокирован');
    }
    _loadUsers();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('заблокирован') ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      appBar: AppBar(
        title: const Text(
          'Управление пользователями',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: user.isBlocked ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: user.isBlocked ? Colors.red.withOpacity(0.5) : Colors.white.withOpacity(0.2),
                width: user.isBlocked ? 2 : 1,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.role == 'admin' ? Colors.red : Colors.green,
                child: Icon(
                  user.role == 'admin' ? Icons.admin_panel_settings : Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: user.isBlocked ? TextDecoration.lineThrough : null,
                  color: user.isBlocked ? Colors.red[300] : Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  Text(
                    'Роль: ' + (user.role == 'admin' ? 'Администратор' : 'Клиент'),
                    style: TextStyle(
                      color: user.role == 'admin' ? Colors.red[300] : Colors.green[300],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: ElevatedButton.icon(
                onPressed: () => _toggleBlock(user),
                icon: Icon(user.isBlocked ? Icons.lock_open : Icons.block),
                label: Text(user.isBlocked ? 'Разблокировать' : 'Заблокировать'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: user.isBlocked ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
