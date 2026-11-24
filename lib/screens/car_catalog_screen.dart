import 'package:flutter/material.dart';
import '../models/car_lot_model.dart';
import '../theme/app_colors.dart';
import 'car_lot_screen.dart';

class CarCatalogScreen extends StatelessWidget {
  final List<CarLotModel> carLots;
  final Function(CarLotModel) onToggleFavorite;
  final Function(CarLotModel) onAddLot;
  final Function(int) onDeleteLot;
  final Function(CarLotModel) onEditLot;
  final Function(CarLotModel) onToggleStatus;

  const CarCatalogScreen({
    super.key,
    required this.carLots,
    required this.onToggleFavorite,
    required this.onAddLot,
    required this.onDeleteLot,
    required this.onEditLot,
    required this.onToggleStatus,
  });

  Map<String, int> _calculateSummary() {
    return {
      'total': carLots.length,
      'favorites': carLots.where((lot) => lot.isFavorite).length,
      'sold': carLots.where((lot) => lot.status == LotStatus.sold).length,
    };
  }

  void _addNewLotDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Додати новий лот Copart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Марка та модель',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Початкова ставка (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredName = nameController.text.trim();
                final enteredPrice = int.tryParse(priceController.text.trim()) ?? 5000;
                if (enteredName.isNotEmpty) {
                  onAddLot(
                    CarLotModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: enteredName,
                      price: enteredPrice,
                      isFavorite: false,
                      status: LotStatus.active,
                    ),
                  );
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Додати'),
            ),
          ],
        );
      },
    );
  }

  void _editLotDialog(BuildContext context, CarLotModel currentLot) {
    final nameController = TextEditingController(text: currentLot.title);
    final priceController = TextEditingController(text: currentLot.price.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Редагувати лот'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Марка та модель',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Поточна ставка (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                final editedName = nameController.text.trim();
                final editedPrice = int.tryParse(priceController.text.trim()) ?? currentLot.price;
                if (editedName.isNotEmpty) {
                  currentLot.title = editedName;
                  currentLot.price = editedPrice;
                  onEditLot(currentLot);
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final summaryStatistics = _calculateSummary();

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${summaryStatistics['total']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text('Всього лотів', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${summaryStatistics['favorites']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    const Text('В обраному', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${summaryStatistics['sold']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    const Text('Викуплено', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: carLots.isEmpty
                ? const Center(
                    child: Text('Список порожній. Додайте нове авто!'),
                  )
                : ListView.builder(
                    itemCount: carLots.length,
                    itemBuilder: (builderContext, lotIndex) {
                      final currentLot = carLots[lotIndex];

                      return Dismissible(
                        key: ValueKey(currentLot.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppColors.error,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          onDeleteLot(lotIndex);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(
                                currentLot.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: currentLot.isFavorite
                                    ? AppColors.error
                                    : AppColors.grey,
                              ),
                              onPressed: () {
                                onToggleFavorite(currentLot);
                              },
                            ),
                            title: Text(
                              currentLot.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: currentLot.status == LotStatus.sold
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: currentLot.status == LotStatus.sold
                                    ? Colors.grey.shade600
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              'Ставка: \$${currentLot.price} | ${currentLot.status == LotStatus.sold ? "Лот викуплено (Sold)" : "Торги відкриті (Active)"}',
                              style: TextStyle(
                                fontSize: 13,
                                color: currentLot.status == LotStatus.sold
                                    ? AppColors.success
                                    : null,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                                  onPressed: () => _editLotDialog(context, currentLot),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                  onPressed: () => onDeleteLot(lotIndex),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (pushContext) => CarLotScreen(
                                    carTitle: currentLot.title,
                                    initialPrice: currentLot.price,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              onToggleStatus(currentLot);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _addNewLotDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
