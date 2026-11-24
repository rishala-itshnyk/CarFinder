import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/car_lot_model.dart';
import 'car_lot_screen.dart';

class CarCatalogScreen extends StatefulWidget {
  const CarCatalogScreen({super.key});

  @override
  State<CarCatalogScreen> createState() => _CarCatalogScreenState();
}

class _CarCatalogScreenState extends State<CarCatalogScreen> {
  List<CarLotModel> _carLots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLotsFromJson();
  }

  Future<void> _loadLotsFromJson() async {
    try {
      final rawContent = await rootBundle.loadString('assets/car_lots.json');
      final parsedJsonList = jsonDecode(rawContent) as List<dynamic>;
      final loadedLots = parsedJsonList
          .map((lotMap) => CarLotModel.fromJson(lotMap as Map<String, dynamic>))
          .toList();

      setState(() {
        _carLots = loadedLots;
        _isLoading = false;
      });
    } catch (loadError) {
      setState(() {
        _carLots = [
          CarLotModel(
            id: 101,
            title: 'Tesla Model 3 Long Range',
            price: 9200,
            isFavorite: true,
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
            isFavorite: true,
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
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLotsToJson() async {
    final encodedJson = jsonEncode(_carLots.map((lot) => lot.toJson()).toList());
    try {
      final storageFile = File('car_lots_saved.json');
      await storageFile.writeAsString(encodedJson);
    } catch (_) {}
  }

  Map<String, int> _calculateSummary() {
    return {
      'total': _carLots.length,
      'favorites': _carLots.where((lot) => lot.isFavorite).length,
      'sold': _carLots.where((lot) => lot.status == LotStatus.sold).length,
    };
  }

  void _addNewLotDialog() {
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
                  setState(() {
                    _carLots.add(
                      CarLotModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: enteredName,
                        price: enteredPrice,
                        isFavorite: false,
                        status: LotStatus.active,
                      ),
                    );
                  });
                  _saveLotsToJson();
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

  void _editLotDialog(CarLotModel currentLot) {
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
                  setState(() {
                    currentLot.title = editedName;
                    currentLot.price = editedPrice;
                  });
                  _saveLotsToJson();
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

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(bottom: BorderSide(color: Colors.blue.shade100)),
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
                        color: Colors.blueAccent,
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
                        color: Colors.redAccent,
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
                        color: Colors.green,
                      ),
                    ),
                    const Text('Викуплено', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _carLots.isEmpty
                ? const Center(
                    child: Text('Список порожній. Додайте нове авто!'),
                  )
                : ListView.builder(
                    itemCount: _carLots.length,
                    itemBuilder: (builderContext, lotIndex) {
                      final currentLot = _carLots[lotIndex];

                      return Dismissible(
                        key: ValueKey(currentLot.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            _carLots.removeAt(lotIndex);
                          });
                          _saveLotsToJson();
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
                                    ? Colors.redAccent
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  currentLot.isFavorite = !currentLot.isFavorite;
                                });
                                _saveLotsToJson();
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
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Ставка: \$${currentLot.price} | ${currentLot.status == LotStatus.sold ? "Лот викуплено (Sold)" : "Торги відкриті (Active)"}',
                              style: TextStyle(
                                fontSize: 13,
                                color: currentLot.status == LotStatus.sold
                                    ? Colors.green.shade700
                                    : Colors.black54,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                                  onPressed: () => _editLotDialog(currentLot),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _carLots.removeAt(lotIndex);
                                    });
                                    _saveLotsToJson();
                                  },
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
                              setState(() {
                                currentLot.status = currentLot.status == LotStatus.sold
                                    ? LotStatus.active
                                    : LotStatus.sold;
                              });
                              _saveLotsToJson();
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
        backgroundColor: Colors.blueAccent,
        onPressed: _addNewLotDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
