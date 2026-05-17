class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final DateTime timestamp;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? visibility;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.timestamp,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.visibility,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List?)?.first ?? {};
    final wind = json['wind'] ?? {};

    return Weather(
      cityName: cityName,
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      description: weather['description'] ?? 'Нет данных',
      iconCode: weather['icon'] ?? '01d',
      timestamp: DateTime.now(),
      tempMin: main['temp_min']?.toDouble(),
      tempMax: main['temp_max']?.toDouble(),
      pressure: main['pressure'],
      visibility: json['visibility'],
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
