import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/weather_api_service.dart';
import '../../models/weather.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/weather_card.dart';
import 'weather_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Weather> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final favoriteCities = SessionService.getFavorites();
    final weatherList = <Weather>[];

    for (final city in favoriteCities) {
      final weather = await WeatherApiService.getWeatherForCity(city);
      if (weather != null) {
        weatherList.add(weather);
      }
    }

    setState(() {
      _favorites = weatherList;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(String cityName) async {
    await SessionService.removeFavorite(cityName);
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Удалено из избранного'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      appBar: AppBar(
        title: const Text(
          'Избранное',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        color: Colors.white,
        backgroundColor: const Color(0xFF1565C0),
        child: _isLoading
            ? const LoadingAnimation(message: 'Загрузка избранного...')
            : _favorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite_border, size: 80, color: Colors.white54),
                        const SizedBox(height: 16),
                        Text(
                          'Нет избранных городов',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Добавьте города из главного экрана',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final weather = _favorites[index];
                      return WeatherCard(
                        weather: weather,
                        isFavorite: true,
                        showFavoriteButton: true,
                        onFavoriteToggle: () => _removeFavorite(weather.cityName),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WeatherDetailScreen(weather: weather),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
