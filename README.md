# WeatherApp - Прогноз погоды

## Описание
Мобильное приложение прогноза погоды на Flutter с поддержкой двух ролей пользователей (Клиент и Администратор).

## Демо-данные для входа

### Клиент:
- Email: client@weather.app
- Пароль: любой

### Администратор:
- Email: admin@weather.app
- Пароль: любой

Или используйте быстрые кнопки на экране входа.

## API
Используется OpenWeatherMap API с ключом, предоставленным в задании.

## Структура проекта
```
lib/
├── main.dart
├── models/
│   ├── user.dart
│   ├── weather.dart
│   ├── city.dart
│   └── notification.dart
├── services/
│   ├── auth_service.dart
│   ├── weather_api_service.dart
│   ├── session_service.dart
│   └── notification_service.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── client/
│   │   ├── client_home_screen.dart
│   │   ├── weather_detail_screen.dart
│   │   └── favorites_screen.dart
│   └── admin/
│       ├── admin_home_screen.dart
│       ├── blocked_users_screen.dart
│       └── notifications_screen.dart
├── widgets/
│   ├── loading_animation.dart
│   ├── weather_card.dart
│   ├── pagination_widget.dart
│   └── notification_badge.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

## Автор
- Разработано в рамках учебного проекта
