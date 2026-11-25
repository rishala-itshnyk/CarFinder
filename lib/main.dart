import 'dart:async';
import 'package:flutter/material.dart';
import 'models/car_lot_model.dart';
import 'screens/login_screen.dart';
import 'screens/main_catalog_screen.dart';
import 'screens/saved_list_screen.dart';
import 'screens/splash_screen.dart';
import 'services/app_storage_service.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const CarFinderApp());
}

class CarFinderApp extends StatefulWidget {
  const CarFinderApp({super.key});

  static _CarFinderAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CarFinderAppState>();

  @override
  State<CarFinderApp> createState() => _CarFinderAppState();
}

class _CarFinderAppState extends State<CarFinderApp> {
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final savedMode = await AppStorageService.loadThemeMode();
    if (mounted) {
      setState(() {
        isDarkMode = savedMode;
      });
    }
  }

  void toggleTheme(bool themeEnabled) async {
    setState(() {
      isDarkMode = themeEnabled;
    });
    await AppStorageService.saveThemeMode(themeEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        primaryColor: AppColors.copartBlue,
        fontFamily: 'CarFinderFont',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.copartBlue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: AppColors.copartBlue,
        fontFamily: 'CarFinderFont',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: const Color(0xFF1E1E1E),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.copartBlue,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final String username;

  const MainNavigationScreen({
    super.key,
    this.username = 'Гість',
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with WidgetsBindingObserver {
  int _activeScreenIndex = 0;
  List<CarLotModel> _carLots = [];
  bool _isLoading = true;
  Timer? _sessionTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLots();
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(minutes: 1), _handleSessionTimeout);
  }

  void _handleSessionTimeout() async {
    await AppStorageService.clearUserProfile();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      _checkSessionFreshness();
    }
  }

  Future<void> _checkSessionFreshness() async {
    final active = await AppStorageService.isSessionActive();
    if (!active) {
      _handleSessionTimeout();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLots() async {
    final loadedList = await AppStorageService.loadCarLotsList();
    final savedFavorites = await AppStorageService.loadFavoriteIdentities();
    for (final lot in loadedList) {
      if (savedFavorites.contains(lot.id.toString())) {
        lot.isFavorite = true;
      }
    }

    if (mounted) {
      setState(() {
        _carLots = loadedList;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(CarLotModel targetLot) async {
    setState(() {
      targetLot.isFavorite = !targetLot.isFavorite;
    });

    final currentFavorites = _carLots
        .where((lot) => lot.isFavorite)
        .map((lot) => lot.id.toString())
        .toList();

    await AppStorageService.saveFavoriteIdentities(currentFavorites);
    await AppStorageService.saveCarLotsList(_carLots);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screens = [
      MainCatalogScreen(username: widget.username),
      SavedListScreen(
        carLots: _carLots,
        onToggleFavorite: _toggleFavorite,
      ),
    ];

    return Scaffold(
      body: screens[_activeScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeScreenIndex,
        backgroundColor: isDark ? Colors.black : Colors.white,
        selectedItemColor: isDark ? Colors.white : Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (selectedTab) {
          setState(() {
            _activeScreenIndex = selectedTab;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined, size: 28),
            activeIcon: Icon(Icons.directions_car, size: 28),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined, size: 28),
            activeIcon: Icon(Icons.article, size: 28),
            label: 'Збереження',
          ),
        ],
      ),
    );
  }
}
