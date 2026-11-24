import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final VoidCallback onNavigateToDetails;

  const HomeScreen({
    super.key,
    required this.username,
    required this.onNavigateToDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Вітаємо, $username!',
              textAlign: TextAlign.center,
              style: AppStyles.title,
            ),
            const SizedBox(height: 8),
            const Text(
              'Сервіс підбору та покупки авто з аукціонів Copart',
              textAlign: TextAlign.center,
              style: AppStyles.subtitle,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onNavigateToDetails,
              icon: const Icon(Icons.search),
              label: const Text(
                'Перейти до каталогу авто',
                style: AppStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
