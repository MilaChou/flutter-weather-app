import 'dart:math';
import '../models/user.dart';
import 'session_service.dart';

class AuthService {
  // Predefined users for auto-detection (no role selection button)
  static final List<User> _users = [
    User(
      id: 'client_001',
      email: 'client@weather.app',
      name: 'Иван Клиентов',
      role: 'client',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: 'admin_001',
      email: 'admin@weather.app',
      name: 'Алексей Админов',
      role: 'admin',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    User(
      id: 'client_002',
      email: 'user@weather.app',
      name: 'Мария Пользователева',
      role: 'client',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  // Auto-detect user by credentials (simulating login without role selection)
  static Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user by email (password check simulated)
    final user = _users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('Пользователь не найден'),
    );

    // Check if blocked
    if (SessionService.isUserBlocked(user.id)) {
      throw Exception('Пользователь заблокирован');
    }

    // Save session
    await SessionService.saveCurrentUser(user);
    return user;
  }

  // Auto-login for demo (detects role automatically)
  static Future<User?> autoLogin(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Auto-detect based on identifier pattern
    User? detectedUser;

    if (identifier.toLowerCase().contains('admin') || 
        identifier == '1' || 
        identifier == 'admin@weather.app') {
      detectedUser = _users.firstWhere((u) => u.role == 'admin');
    } else {
      detectedUser = _users.firstWhere((u) => u.role == 'client');
    }

    if (SessionService.isUserBlocked(detectedUser.id)) {
      throw Exception('Пользователь заблокирован');
    }

    await SessionService.saveCurrentUser(detectedUser);
    return detectedUser;
  }

  static User? getCurrentUser() {
    return SessionService.getCurrentUser();
  }

  static Future<void> logout() async {
    await SessionService.clearCurrentUser();
  }

  static List<User> getAllUsers() {
    return _users.map((u) {
      final isBlocked = SessionService.isUserBlocked(u.id);
      return u.copyWith(isBlocked: isBlocked);
    }).toList();
  }

  static Future<void> blockUser(String userId) async {
    await SessionService.addBlockedUser(userId);
  }

  static Future<void> unblockUser(String userId) async {
    await SessionService.removeBlockedUser(userId);
  }
}
