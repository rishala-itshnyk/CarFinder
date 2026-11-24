import 'package:flutter/material.dart';
import 'screens/car_catalog_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const CarFinderApp());
}

class CarFinderApp extends StatelessWidget {
  const CarFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
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
    final screens = [
      HomeScreen(
        username: widget.username,
        onNavigateToDetails: () => _selectScreen(1),
      ),
      const CarCatalogScreen(),
    ];

    final screenTitles = [
      'Головна',
      'Каталог авто (Copart)',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitles[_activeScreenIndex]),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Вийти',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (logoutContext) => const RegisterScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: screens[_activeScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeScreenIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Головна',
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
