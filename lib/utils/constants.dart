import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  static const String apiKey = '109ba5bbd3120f8691d82e96bcadba2d';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String iconUrl = 'https://openweathermap.org/img/wn';

  // Pagination
  static const int itemsPerPage = 5;

  // User Roles
  static const String roleClient = 'client';
  static const String roleAdmin = 'admin';

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF03A9F4);
  static const Color adminColor = Color(0xFFE53935);
  static const Color clientColor = Color(0xFF43A047);

  // 40 Cities for demonstration
  static const List<String> cities = [
    'Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Казань',
    'Нижний Новгород', 'Челябинск', 'Самара', 'Омск', 'Ростов-на-Дону',
    'Уфа', 'Красноярск', 'Воронеж', 'Пермь', 'Волгоград',
    'Краснодар', 'Саратов', 'Тюмень', 'Тольятти', 'Ижевск',
    'Барнаул', 'Ульяновск', 'Иркутск', 'Хабаровск', 'Ярославль',
    'Владивосток', 'Махачкала', 'Томск', 'Оренбург', 'Кемерово',
    'Новокузнецк', 'Рязань', 'Астрахань', 'Набережные Челны', 'Пенза',
    'Липецк', 'Киров', 'Чебоксары', 'Тула', 'Калининград'
  ];
}
