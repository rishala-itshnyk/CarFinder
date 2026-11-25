import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_storage_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    final sessionActive = await AppStorageService.isSessionActive();
    final profile = await AppStorageService.loadUserProfile();
    final savedName = profile['name'] ?? '';

    if (!mounted) return;

    if (sessionActive && savedName.isNotEmpty) {
      await AppStorageService.clearExitTimestamp();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (screenContext, _, __) => MainNavigationScreen(
            username: savedName,
          ),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      if (savedName.isNotEmpty) {
        await AppStorageService.clearUserProfile();
      }
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (screenContext, _, __) => const LoginScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/car_logo.png',
          width: 160,
        ),
      ),
    );
  }
}
