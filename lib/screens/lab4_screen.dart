import 'package:flutter/material.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/bottom_image.dart';
import '../widgets/feature_card.dart';
import '../widgets/header_block.dart';

class Lab4Screen extends StatelessWidget {
  const Lab4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HeaderBlock(
            title: 'Tesla Model 3 Long Range',
            description: 'Аукціонний лот Copart #54219802 (США)',
          ),
          const SizedBox(height: 12),
          const FeatureCard(
            icon: Icons.car_crash_outlined,
            title: 'Лобове пошкодження (Front End)',
            subtitle: 'Пошкоджено бампер та капот. Батарея 75 kWh неушкоджена',
          ),
          const SizedBox(height: 12),
          const FeatureCard(
            icon: Icons.check_circle_outline,
            title: 'Статус аукціону Run & Drive',
            subtitle: 'Авто заводиться і їде. Ключі та Salvage Certificate є',
          ),
          const Spacer(),
          ActionButtonsRow(
            primaryText: 'Зробити ставку',
            secondaryText: 'Звіт Carfax',
            onPrimary: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ставку \$9,500 на Tesla Model 3 зареєстровано!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onSecondary: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carfax: 1 власник, регулярне ТО, чиста історія пробігу.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const BottomImage(
            imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=1000&q=80',
          ),
        ],
      ),
    );
  }
}
