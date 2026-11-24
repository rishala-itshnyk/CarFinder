import 'package:flutter/material.dart';
import 'screens/car_catalog_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const CarFinderApp());
}

class CarFinderApp extends StatefulWidget {
  const CarFinderApp({super.key});

  @override
  State<CarFinderApp> createState() => _CarFinderAppState();
}

class _CarFinderAppState extends State<CarFinderApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool themeEnabled) {
    setState(() {
      _isDarkMode = themeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        primaryColor: AppColors.primary,
        fontFamily: 'CarFinderFont',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        primaryColor: AppColors.secondary,
        fontFamily: 'CarFinderFont',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cardDark,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardColor: AppColors.cardDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          brightness: Brightness.dark,
        ),
      ),
      home: const RegisterScreen(),
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

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _activeScreenIndex = 0;

  void _selectScreen(int screenIndex) {
    setState(() {
      _activeScreenIndex = screenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.findAncestorStateOfType<_CarFinderAppState>();
    final isDark = appState?._isDarkMode ?? false;

    final screens = [
      HomeScreen(
        username: widget.username,
        onNavigateToDetails: () => _selectScreen(1),
      ),
      const CarCatalogScreen(),
      ProfileScreen(
        username: widget.username,
        isDarkMode: isDark,
        onThemeChanged: (themeEnabled) {
          appState?._toggleTheme(themeEnabled);
        },
      ),
    ];

    final screenTitles = [
      'Головна',
      'Каталог авто (Copart)',
      'Профіль користувача',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitles[_activeScreenIndex]),
      ),
      body: screens[_activeScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeScreenIndex,
        selectedItemColor: isDark ? AppColors.secondary : AppColors.primary,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
