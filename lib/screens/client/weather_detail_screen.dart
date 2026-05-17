import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/weather.dart';
import '../../services/weather_api_service.dart';
import '../../widgets/loading_animation.dart';
import '../../utils/helpers.dart';

class WeatherDetailScreen extends StatefulWidget {
  final Weather weather;

  const WeatherDetailScreen({Key? key, required this.weather}) : super(key: key);

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  List<Weather>? _forecast;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  Future<void> _loadForecast() async {
    final forecast = await WeatherApiService.getForecast(widget.weather.cityName);
    setState(() {
      _forecast = forecast;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: CustomScrollView(
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: _getTemperatureColor(widget.weather.temperature),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.weather.cityName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getTemperatureColor(widget.weather.temperature),
                      _getTemperatureColor(widget.weather.temperature).withOpacity(0.7),
                      const Color(0xFF0D47A1),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        widget.weather.iconUrl,
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.cloud, size: 120, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Helpers.formatTemperature(widget.weather.temperature),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Helpers.capitalize(widget.weather.description),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Main info card
                  _buildGlassCard(
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.thermostat,
                          'Температура',
                          Helpers.formatTemperature(widget.weather.temperature),
                          Colors.orange,
                        ),
                        const Divider(height: 24, color: Colors.white24),
                        _buildDetailRow(
                          Icons.thermostat_outlined,
                          'Ощущается как',
                          Helpers.formatTemperature(widget.weather.feelsLike),
                          Colors.red,
                        ),
                        if (widget.weather.tempMin != null) ...[
                          const Divider(height: 24, color: Colors.white24),
                          _buildDetailRow(
                            Icons.arrow_downward,
                            'Минимум',
                            Helpers.formatTemperature(widget.weather.tempMin!),
                            Colors.blue,
                          ),
                        ],
                        if (widget.weather.tempMax != null) ...[
                          const Divider(height: 24, color: Colors.white24),
                          _buildDetailRow(
                            Icons.arrow_upward,
                            'Максимум',
                            Helpers.formatTemperature(widget.weather.tempMax!),
                            Colors.green,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Secondary info card
                  _buildGlassCard(
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.water_drop,
                          'Влажность',
                          '${widget.weather.humidity}%',
                          Colors.cyan,
                        ),
                        const Divider(height: 24, color: Colors.white24),
                        _buildDetailRow(
                          Icons.air,
                          'Скорость ветра',
                          '${widget.weather.windSpeed} м/с',
                          Colors.teal,
                        ),
                        if (widget.weather.pressure != null) ...[
                          const Divider(height: 24, color: Colors.white24),
                          _buildDetailRow(
                            Icons.speed,
                            'Давление',
                            '${widget.weather.pressure} гПа',
                            Colors.purple,
                          ),
                        ],
                        if (widget.weather.visibility != null) ...[
                          const Divider(height: 24, color: Colors.white24),
                          _buildDetailRow(
                            Icons.visibility,
                            'Видимость',
                            '${(widget.weather.visibility! / 1000).toStringAsFixed(1)} км',
                            Colors.indigo,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Forecast section
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.8)),
                            const SizedBox(width: 8),
                            Text(
                              'Прогноз на 5 дней',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _isLoading
                            ? const SizedBox(
                                height: 100,
                                child: LoadingAnimation(message: 'Загрузка прогноза...'),
                              )
                            : _forecast == null || _forecast!.isEmpty
                                ? Center(
                                    child: Text(
                                      'Прогноз недоступен',
                                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                    ),
                                  )
                                : Column(
                                    children: _forecast!
                                        .take(8)
                                        .map((w) => _buildForecastItem(w))
                                        .toList(),
                                  ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastItem(Weather weather) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(
            weather.iconUrl,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud, size: 40, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Helpers.formatDate(weather.timestamp),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                Text(
                  Helpers.capitalize(weather.description),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Helpers.formatTemperature(weather.temperature),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp < -10) return Colors.indigo;
    if (temp < 0) return Colors.blue;
    if (temp < 10) return Colors.cyan;
    if (temp < 20) return Colors.teal;
    if (temp < 30) return Colors.orange;
    return Colors.red;
  }
}
