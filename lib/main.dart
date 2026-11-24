import 'package:flutter/material.dart';
import 'car_details_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const CarFinderApp());
}

class CarFinderApp extends StatelessWidget {
  const CarFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

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
    final screens = [
      HomeScreen(
        onNavigateToDetails: () => _selectScreen(1),
      ),
      const CarDetailsScreen(),
    ];

    final screenTitles = [
      'Пошук авто',
      'Деталі лота Copart',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitles[_activeScreenIndex]),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: screens[_activeScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeScreenIndex,
        selectedItemColor: Colors.blue,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Пошук',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Каталог авто',
          ),
        ],
      ),
    );
  }
}
