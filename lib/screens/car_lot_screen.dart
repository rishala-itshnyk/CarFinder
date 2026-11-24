import 'package:flutter/material.dart';
import '../widgets/bottom_image.dart';
import '../widgets/feature_card.dart';
import '../widgets/header_block.dart';

class CarLotScreen extends StatefulWidget {
  const CarLotScreen({super.key});

  @override
  State<CarLotScreen> createState() => _CarLotScreenState();
}

class _CarLotScreenState extends State<CarLotScreen> {
  bool _isFavorite = false;
  int _bidCounter = 12;
  String _buyerNote = '';
  bool _includeDelivery = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: HeaderBlock(
                    title: 'Tesla Model 3 Long Range',
                    description: 'Аукціон Copart #54219802 | Run & Drive',
                  ),
                ),
                IconButton(
                  iconSize: 32,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gavel, color: Colors.blueAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Поточна ставка: \$9,200 (ставок: $_bidCounter)',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _bidCounter++;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ставку підвищено! Загалом ставок: $_bidCounter'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text('+ \$100'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Доставка в порт (Одеса / Клайпеда)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _includeDelivery
                    ? 'Вартість доставки: + \$1,850 | Термін: 35 днів'
                    : 'Самовивіз з майданчика Copart у США',
                style: TextStyle(
                  color: _includeDelivery ? Colors.green.shade700 : Colors.grey.shade600,
                  fontWeight: _includeDelivery ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              secondary: Icon(
                Icons.local_shipping,
                color: _includeDelivery ? Colors.green : Colors.grey,
              ),
              activeColor: Colors.blueAccent,
              value: _includeDelivery,
              onChanged: (deliverySelected) {
                setState(() {
                  _includeDelivery = deliverySelected;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Коментар покупця або VIN-запит',
                hintText: 'Наприклад: Перевірити стан батареї',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_note),
              ),
              onChanged: (enteredText) {
                setState(() {
                  _buyerNote = enteredText;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _buyerNote.isEmpty
                    ? 'Введіть коментар вище для попереднього перегляду'
                    : 'Ваш запит: $_buyerNote',
                style: TextStyle(
                  fontSize: 13,
                  color: _buyerNote.isEmpty ? Colors.grey.shade500 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const FeatureCard(
              icon: Icons.car_crash_outlined,
              title: 'Лобове пошкодження (Front End)',
              subtitle: 'Бампер та капот пошкоджені. Батарея та геометрія цілі.',
            ),
            const SizedBox(height: 12),
            const BottomImage(
              imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=1000&q=80',
            ),
          ],
        ),
      ),
    );
  }
}
