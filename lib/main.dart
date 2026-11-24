import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'models/car_lot_model.dart';
import 'screens/car_catalog_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'services/app_storage_service.dart';
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
  String _savedUsername = '';
  bool _isCheckingStorage = true;

  @override
  void initState() {
    super.initState();
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final profile = await AppStorageService.loadUserProfile();
    final name = profile['name'] ?? '';
    setState(() {
      _savedUsername = name;
      _isCheckingStorage = false;
    });
  }

  void _toggleTheme(bool themeEnabled) {
    setState(() {
      _isDarkMode = themeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingStorage) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

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
      home: _savedUsername.isNotEmpty
          ? MainNavigationScreen(username: _savedUsername)
          : const RegisterScreen(),
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
  List<CarLotModel> _carLots = [];
  bool _isLoadingLots = true;

  @override
  void initState() {
    super.initState();
    _loadInitialLots();
  }

  Future<void> _loadInitialLots() async {
    List<CarLotModel> loadedList = [];
    try {
      final rawContent = await rootBundle.loadString('assets/car_lots.json');
      final parsedList = jsonDecode(rawContent) as List<dynamic>;
      loadedList = parsedList
          .map((lotMap) => CarLotModel.fromJson(lotMap as Map<String, dynamic>))
          .toList();
    } catch (_) {
      loadedList = [
        CarLotModel(
          id: 101,
          title: 'Tesla Model 3 Long Range',
          price: 9200,
          isFavorite: false,
          status: LotStatus.active,
        ),
        CarLotModel(
          id: 102,
          title: 'BMW M3 Competition G80',
          price: 18500,
          isFavorite: false,
          status: LotStatus.active,
        ),
        CarLotModel(
          id: 103,
          title: 'Audi RS6 Avant Quattro',
          price: 24000,
          isFavorite: false,
          status: LotStatus.sold,
        ),
        CarLotModel(
          id: 104,
          title: 'Ford Mustang GT 5.0 V8',
          price: 11300,
          isFavorite: false,
          status: LotStatus.active,
        ),
        CarLotModel(
          id: 105,
          title: 'Porsche Taycan 4S Electric',
          price: 29800,
          isFavorite: false,
          status: LotStatus.sold,
        ),
      ];
    }

    final savedFavorites = await AppStorageService.loadFavoriteIdentities();
    for (final lot in loadedList) {
      if (savedFavorites.contains(lot.id.toString())) {
        lot.isFavorite = true;
      }
    }

    setState(() {
      _carLots = loadedList;
      _isLoadingLots = false;
    });
  }

  Future<void> _toggleLotFavorite(CarLotModel targetLot) async {
    setState(() {
      targetLot.isFavorite = !targetLot.isFavorite;
    });

    final currentFavorites = _carLots
        .where((lot) => lot.isFavorite)
        .map((lot) => lot.id.toString())
        .toList();

    await AppStorageService.saveFavoriteIdentities(currentFavorites);
  }

  void _addLot(CarLotModel newLot) {
    setState(() {
      _carLots.add(newLot);
    });
  }

  void _deleteLot(int lotIndex) async {
    final deletedLot = _carLots[lotIndex];
    setState(() {
      _carLots.removeAt(lotIndex);
    });

    if (deletedLot.isFavorite) {
      final currentFavorites = _carLots
          .where((lot) => lot.isFavorite)
          .map((lot) => lot.id.toString())
          .toList();
      await AppStorageService.saveFavoriteIdentities(currentFavorites);
    }
  }

  void _editLot(CarLotModel modifiedLot) {
    setState(() {});
  }

  void _toggleLotStatus(CarLotModel targetLot) {
    setState(() {
      targetLot.status = targetLot.status == LotStatus.sold
          ? LotStatus.active
          : LotStatus.sold;
    });
  }

  void _selectScreen(int screenIndex) {
    setState(() {
      _activeScreenIndex = screenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.findAncestorStateOfType<_CarFinderAppState>();
    final isDark = appState?._isDarkMode ?? false;

    if (_isLoadingLots) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screens = [
      HomeScreen(
        username: widget.username,
        onNavigateToDetails: () => _selectScreen(1),
      ),
      CarCatalogScreen(
        carLots: _carLots,
        onToggleFavorite: _toggleLotFavorite,
        onAddLot: _addLot,
        onDeleteLot: _deleteLot,
        onEditLot: _editLot,
        onToggleStatus: _toggleLotStatus,
      ),
      FavoritesScreen(
        carLots: _carLots,
        onToggleFavorite: _toggleLotFavorite,
      ),
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
      'Обрані лоти (Favorites)',
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
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.favorite),
            label: 'Обране',
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
