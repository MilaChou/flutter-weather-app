import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';

class WeatherApiService {
  static Future<Weather?> getWeatherForCity(String cityName) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}/weather?q=$cityName&appid=${AppConstants.apiKey}&units=metric&lang=ru'
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data, cityName);
      } else {
        print('API Error for $cityName: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception for $cityName: $e');
      return null;
    }
  }

  static Future<List<Weather>> getWeatherForCities(List<String> cities) async {
    final results = <Weather>[];

    for (final city in cities) {
      final weather = await getWeatherForCity(city);
      if (weather != null) {
        results.add(weather);
      }
      // Small delay to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return results;
  }

  // Get forecast for next 5 days (3-hour intervals)
  static Future<List<Weather>?> getForecast(String cityName) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}/forecast?q=$cityName&appid=${AppConstants.apiKey}&units=metric&lang=ru'
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['list'] as List;

        return list.map((item) {
          final weather = Weather.fromJson(item, cityName);
          return weather.copyWith(timestamp: DateTime.parse(item['dt_txt']));
        }).toList();
      }
      return null;
    } catch (e) {
      print('Forecast exception: $e');
      return null;
    }
  }
}

extension on Weather {
  Weather copyWith({DateTime? timestamp}) {
    return Weather(
      cityName: cityName,
      temperature: temperature,
      feelsLike: feelsLike,
      humidity: humidity,
      windSpeed: windSpeed,
      description: description,
      iconCode: iconCode,
      timestamp: timestamp ?? this.timestamp,
      tempMin: tempMin,
      tempMax: tempMax,
      pressure: pressure,
      visibility: visibility,
    );
  }
}
