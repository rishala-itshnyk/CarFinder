import 'package:flutter/material.dart';
import '../services/app_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _searchNotificationsEnabled = true;
  bool _savedCarsNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettingsFromStorage();
  }

  Future<void> _loadSettingsFromStorage() async {
    final settingsMap = await AppStorageService.loadNotificationSettings();
    if (mounted) {
      setState(() {
        _searchNotificationsEnabled = settingsMap['search'] ?? true;
        _savedCarsNotificationsEnabled = settingsMap['saved_cars'] ?? true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Пошукові запити',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                'Отримувати повідомлення про нові авто з ваших пошукових запитів',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 12,
                  color: isDark ? Colors.white70 : AppColors.grey,
                ),
              ),
              value: _searchNotificationsEnabled,
              activeColor: AppColors.copartBlue,
              onChanged: (switchStatus) async {
                setState(() {
                  _searchNotificationsEnabled = switchStatus;
                });
                await AppStorageService.saveNotificationSettings(
                  searchAlerts: switchStatus,
                  savedCarAlerts: _savedCarsNotificationsEnabled,
                );
              },
            ),
            Divider(height: 24, color: isDark ? Colors.white12 : Colors.grey.shade300),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Збережені авто',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                'Отримувати повідомлення про кожну зміну інформації (ціна, статус) авто',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 12,
                  color: isDark ? Colors.white70 : AppColors.grey,
                ),
              ),
              value: _savedCarsNotificationsEnabled,
              activeColor: AppColors.copartBlue,
              onChanged: (switchStatus) async {
                setState(() {
                  _savedCarsNotificationsEnabled = switchStatus;
                });
                await AppStorageService.saveNotificationSettings(
                  searchAlerts: _searchNotificationsEnabled,
                  savedCarAlerts: switchStatus,
                );
              },
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await AppStorageService.clearNotificationsList();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Історію повідомлень успішно видалено!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'ВИДАЛИТИ ІСТОРІЮ',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
