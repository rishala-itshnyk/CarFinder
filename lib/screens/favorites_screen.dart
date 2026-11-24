import 'package:flutter/material.dart';
import '../models/car_lot_model.dart';
import '../services/app_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'car_lot_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<CarLotModel> carLots;
  final Function(CarLotModel) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.carLots,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favoriteIdentities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final loadedIds = await AppStorageService.loadFavoriteIdentities();
    setState(() {
      _favoriteIdentities = loadedIds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final favoriteLots = widget.carLots
        .where((lot) => _favoriteIdentities.contains(lot.id.toString()) || lot.isFavorite)
        .toList();

    if (favoriteLots.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 70, color: AppColors.grey),
            SizedBox(height: 12),
            Text(
              'Список обраного порожній',
              style: AppStyles.title,
            ),
            SizedBox(height: 6),
            Text(
              'Додайте лоти з каталогу за допомогою сердечка',
              style: AppStyles.subtitle,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favoriteLots.length,
      itemBuilder: (builderContext, lotIndex) {
        final currentLot = favoriteLots[lotIndex];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: ListTile(
            leading: IconButton(
              icon: const Icon(Icons.favorite, color: AppColors.error),
              onPressed: () async {
                widget.onToggleFavorite(currentLot);
                setState(() {
                  _favoriteIdentities.remove(currentLot.id.toString());
                });
                await AppStorageService.saveFavoriteIdentities(_favoriteIdentities);
              },
            ),
            title: Text(
              currentLot.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Ставка: \$${currentLot.price} | Лот Copart',
              style: AppStyles.body,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
          ),
        );
      },
    );
  }
}
