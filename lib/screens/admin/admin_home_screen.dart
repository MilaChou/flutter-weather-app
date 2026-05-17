import 'package:flutter/material.dart';
import '../../models/weather.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../services/weather_api_service.dart';
import '../../services/notification_service.dart';
import '../../utils/constants.dart';
import '../../utils/app_styles.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/notification_badge.dart';
import '../login_screen.dart';
import 'blocked_users_screen.dart';
import 'notifications_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Weather> _allWeather = [];
  List<Weather> _displayedWeather = [];
  List<Weather> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  int _currentPage = 1;
  int _totalPages = 1;
  String? _userName;
  int _unreadNotifications = 0;
  final _searchController = TextEditingController();

  // Filters
  String _tempFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadWeather();
    _updateNotificationCount();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      _updateNotificationCount();
      return true;
    });
  }

  void _loadUserData() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _userName = user.name;
      });
    }
  }

  void _updateNotificationCount() {
    final count = NotificationService.getUnreadCount();
    if (count != _unreadNotifications) {
      setState(() {
        _unreadNotifications = count;
      });
    }
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _isSearching = false;
      _searchController.clear();
    });

    try {
      final weatherList = await WeatherApiService.getWeatherForCities(
        AppConstants.cities,
      );

      setState(() {
        _allWeather = weatherList;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Ошибка загрузки данных: ' + e.toString());
    }
  }

  void _applyFilters() {
    var filtered = List<Weather>.from(_allWeather);

    if (_tempFilter == 'cold') {
      filtered = filtered.where((w) => w.temperature < 10).toList();
    } else if (_tempFilter == 'warm') {
      filtered = filtered.where((w) => w.temperature >= 10 && w.temperature < 25).toList();
    } else if (_tempFilter == 'hot') {
      filtered = filtered.where((w) => w.temperature >= 25).toList();
    }

    _totalPages = (filtered.length / AppConstants.itemsPerPage).ceil();
    if (_totalPages == 0) _totalPages = 1;

    final startIndex = (_currentPage - 1) * AppConstants.itemsPerPage;
    final endIndex = startIndex + AppConstants.itemsPerPage;

    if (startIndex < filtered.length) {
      _displayedWeather = filtered.sublist(
        startIndex,
        endIndex > filtered.length ? filtered.length : endIndex,
      );
    } else {
      _displayedWeather = [];
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _applyFilters();
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _applyFilters();
      });
    }
  }

  Future<void> _searchCity(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      final weather = await WeatherApiService.getWeatherForCity(query.trim());
      setState(() {
        if (weather != null) {
          _searchResults = [weather];
        } else {
          _searchResults = [];
        }
        _isLoading = false;
      });

      if (weather == null) {
        _showError('Город не найден. Проверьте название.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Ошибка поиска: ' + e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(AppStyles.errorSnack(message));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(AppStyles.successSnack(message));
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Фильтры', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Температура:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            _buildRadioTile('Все', 'all'),
            _buildRadioTile('Холодно (<10°C)', 'cold'),
            _buildRadioTile('Тепло (10-25°C)', 'warm'),
            _buildRadioTile('Жарко (>25°C)', 'hot'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentPage = 1;
                _applyFilters();
              });
            },
            child: const Text('Применить', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _tempFilter,
      onChanged: (val) {
        setState(() {
          _tempFilter = val!;
        });
        Navigator.pop(context);
        _showFilterDialog();
      },
      activeColor: Colors.blue,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundAdmin,
      appBar: AppBar(
        title: const Text(
          'Администрирование',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          NotificationBadge(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ).then((_) => _updateNotificationCount());
            },
          ),
          IconButton(
            icon: const Icon(Icons.block),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BlockedUsersScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Выйти'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeather,
        color: Colors.white,
        backgroundColor: const Color(0xFF283593),
        child: _isLoading && !_isSearching
            ? const LoadingAnimation(message: 'Загрузка погоды...')
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: AppStyles.searchDecoration,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: AppStyles.searchInputDecoration(
              hint: 'Поиск города...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7)),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                          _searchResults = [];
                        });
                      },
                    )
                  : null,
            ),
            onSubmitted: _searchCity,
            textInputAction: TextInputAction.search,
          ),
        ),

        if (_isSearching && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[300], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Результаты поиска',
                  style: TextStyle(
                    color: Colors.green[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchResults = [];
                      _searchController.clear();
                    });
                  },
                  child: const Text(
                    'Сбросить',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),

        // Admin Info Banner
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.admin_panel_settings, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Администратор: ' + (_userName ?? ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_unreadNotifications > 0) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _unreadNotifications.toString() + ' новых',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

        // Stats Cards
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard(
                  'Всего городов',
                  AppConstants.cities.length.toString(),
                  Icons.location_city,
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Загружено',
                  _allWeather.length.toString(),
                  Icons.cloud_done,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Заблокировано',
                  SessionService.getBlockedUsers().length.toString(),
                  Icons.block,
                  Colors.red,
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        Expanded(
          child: _isSearching
              ? _buildSearchResults()
              : _buildWeatherList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Введите название города',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final weather = _searchResults[index];
        return WeatherCard(
          weather: weather,
          showFavoriteButton: false,
          onTap: () {
            _showMessage(weather.cityName + ': ' + weather.description);
          },
        );
      },
    );
  }

  Widget _buildWeatherList() {
    if (_displayedWeather.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 80, color: Colors.white54),
            const SizedBox(height: 16),
            Text(
              'Нет данных о погоде',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Обновить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _displayedWeather.length + 1,
      itemBuilder: (context, index) {
        if (index == _displayedWeather.length) {
          return PaginationWidget(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onNext: _nextPage,
            onPrevious: _currentPage > 1 ? _previousPage : null,
            hasMore: _currentPage < _totalPages,
          );
        }

        final weather = _displayedWeather[index];

        return WeatherCard(
          weather: weather,
          showFavoriteButton: false,
          onTap: () {
            _showMessage(weather.cityName + ': ' + weather.description);
          },
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
