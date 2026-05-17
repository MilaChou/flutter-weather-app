# WeatherApp - Прогноз погоды

## Описание
Мобильное приложение прогноза погоды на Flutter с поддержкой двух ролей пользователей (Клиент и Администратор).

## Функционал

### Для оценки "Отлично":
- ✅ Минимум 2 пользователя (Клиент и Администратор)
- ✅ Сохранение сессий (избранное клиента, заблокированные пользователи админа)
- ✅ Анимация загрузки при подгрузке данных из API
- ✅ Пагинация: вывод по 5 элементов с кнопками навигации

### Для работы в группе:
- ✅ 40 городов в базе данных
- ✅ Приветственное окно с анимацией (вращающееся солнце, движущиеся облака)
- ✅ Автоопределение роли пользователя (без кнопки выбора роли)
- ✅ Иконка уведомлений с бейджем для администратора

## Установка

1. Убедитесь, что у вас установлен Flutter SDK
2. Склонируйте проект
3. Выполните:
```bash
flutter pub get
flutter run
```

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

## Авторы
- Разработано в рамках учебного проекта
