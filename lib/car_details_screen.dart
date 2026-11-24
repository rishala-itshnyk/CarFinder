import 'package:flutter/material.dart';

class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ставку \$9,500 на Tesla Model 3 успішно зроблено!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.gavel, size: 18),
                  label: const Text('Зробити ставку'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Звіт Carfax: 1 власник, статус Run & Drive, лобовий удар.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.description, size: 18),
                  label: const Text('Звіт Carfax'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tesla Model 3 Long Range / Лот Copart #54219802',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Основне пошкодження: Front End (лобове зіткнення, бампер, капот). Електродвигун та високовольтна батарея 75 kWh без деформацій. Аукціонний статус: Run & Drive. Документи: Salvage Certificate.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Рік випуску: 2021 | Пробіг: 34,210 mi (55,055 км)\nПривід: Dual Motor AWD | Ключі: В наявності\nПорт призначення: Одеса / Клайпеда (35 днів)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.35,
                  ),
                ),
                const Spacer(),
                Text(
                  'Поточна ставка: \$9,200 | Оціночна ціна цілого авто: \$28,500. Віджет Spacer утримує цей блок знизу Expanded без фіксованої висоти.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 190,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.shade300),
            ),
            child: Image.network(
              'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=1000&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, errorObject, stackTrace) {
                return Container(
                  color: Colors.blueGrey.shade900,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.car_crash,
                        size: 64,
                        color: Colors.amber,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Copart Lot: Tesla Model 3 (Front Damage)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
