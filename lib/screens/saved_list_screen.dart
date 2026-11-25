import 'package:flutter/material.dart';
import '../models/car_lot_model.dart';
import '../services/app_storage_service.dart';
import '../theme/app_colors.dart';
import 'car_lot_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';

class SavedListScreen extends StatefulWidget {
  final List<CarLotModel> carLots;
  final Function(CarLotModel) onToggleFavorite;

  const SavedListScreen({
    super.key,
    required this.carLots,
    required this.onToggleFavorite,
  });

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  int _categoryTab = 0;
  String _selectedAuction = 'COPART';
  List<String> _favoriteIdentities = [];
  List<Map<String, String>> _savedQueries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final loadedIds = await AppStorageService.loadFavoriteIdentities();
    final loadedQueries = await AppStorageService.loadSearchQueriesList();
    if (mounted) {
      setState(() {
        _favoriteIdentities = loadedIds;
        _savedQueries = loadedQueries;
        _isLoading = false;
      });
    }
  }

  void _deleteQuery(int indexInFilteredList, Map<String, String> queryToDelete) async {
    setState(() {
      _savedQueries.remove(queryToDelete);
    });
    await AppStorageService.saveSearchQueriesList(_savedQueries);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Пошуковий запит видалено'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredCars = widget.carLots.where((lot) {
      final isSaved = _favoriteIdentities.contains(lot.id.toString()) || lot.isFavorite;
      final matchesAuction = lot.auction.toUpperCase() == _selectedAuction;
      return isSaved && matchesAuction;
    }).toList();

    final filteredQueries = _savedQueries.where((queryItem) {
      return (queryItem['auction'] ?? 'COPART').toUpperCase() == _selectedAuction;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Збереження'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (screenContext) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _categoryTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _categoryTab == 0
                                ? (isDark ? Colors.white : Colors.black)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'АВТО',
                        style: TextStyle(
                          fontFamily: 'CarFinderFont',
                          fontWeight: FontWeight.bold,
                          color: _categoryTab == 0
                              ? (isDark ? Colors.white : Colors.black)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _categoryTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _categoryTab == 1
                                ? (isDark ? Colors.white : Colors.black)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ЗАПИТИ',
                        style: TextStyle(
                          fontFamily: 'CarFinderFont',
                          fontWeight: FontWeight.bold,
                          color: _categoryTab == 1
                              ? (isDark ? Colors.white : Colors.black)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedAuction == 'IAAI'
                          ? AppColors.iaaiRed
                          : (isDark ? const Color(0xFF262626) : Colors.grey.shade200),
                      foregroundColor: _selectedAuction == 'IAAI'
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => setState(() => _selectedAuction = 'IAAI'),
                    child: const Text(
                      'IAAI',
                      style: TextStyle(
                        fontFamily: 'CarFinderFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedAuction == 'COPART'
                          ? AppColors.copartBlue
                          : (isDark ? const Color(0xFF262626) : Colors.grey.shade200),
                      foregroundColor: _selectedAuction == 'COPART'
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => setState(() => _selectedAuction = 'COPART'),
                    child: const Text(
                      'COPART',
                      style: TextStyle(
                        fontFamily: 'CarFinderFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _categoryTab == 0
                ? (filteredCars.isEmpty
                    ? Center(
                        child: Text(
                          'Немає збережених авто для $_selectedAuction',
                          style: const TextStyle(
                            fontFamily: 'CarFinderFont',
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCars.length,
                        itemBuilder: (builderContext, itemIndex) {
                          final lot = filteredCars[itemIndex];

                          return Card(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isDark ? Colors.white12 : Colors.grey.shade300,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (screenContext) => CarLotScreen(
                                      carTitle: lot.title,
                                      initialPrice: lot.price,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 110,
                                          height: 75,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? const Color(0xFF262626)
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Image.network(
                                            'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=400&q=80',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, errorObject, stackTrace) {
                                              return const Icon(
                                                Icons.directions_car,
                                                size: 40,
                                                color: AppColors.copartBlue,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lot.title,
                                                style: TextStyle(
                                                  fontFamily: 'CarFinderFont',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: isDark ? Colors.white : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'VIN: 5YJSA1E21LF... [${lot.auction}]',
                                                style: TextStyle(
                                                  fontFamily: 'CarFinderFont',
                                                  fontSize: 10,
                                                  color: isDark ? Colors.white60 : Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '54,340 mi\nСтан: Run & Drive\nПошкодження: Front\nAll wheel drive',
                                                style: TextStyle(
                                                  fontFamily: 'CarFinderFont',
                                                  fontSize: 11,
                                                  height: 1.25,
                                                  color: isDark ? Colors.white70 : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.favorite, color: AppColors.error),
                                          onPressed: () async {
                                            widget.onToggleFavorite(lot);
                                            setState(() {
                                              _favoriteIdentities.remove(lot.id.toString());
                                            });
                                            await AppStorageService.saveFavoriteIdentities(
                                              _favoriteIdentities,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 16,
                                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                                    ),
                                    Text(
                                      'Ціна зараз: ${lot.price}',
                                      style: TextStyle(
                                        fontFamily: 'CarFinderFont',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ))
                : (filteredQueries.isEmpty
                    ? Center(
                        child: Text(
                          'Немає збережених пошукових запитів для $_selectedAuction',
                          style: const TextStyle(
                            fontFamily: 'CarFinderFont',
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredQueries.length,
                        itemBuilder: (builderContext, queryIndex) {
                          final query = filteredQueries[queryIndex];

                          return Card(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isDark ? Colors.white12 : Colors.grey.shade300,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _selectedAuction == 'IAAI'
                                      ? AppColors.iaaiRed.withOpacity(0.12)
                                      : AppColors.copartBlue.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.saved_search,
                                  color: _selectedAuction == 'IAAI' ? AppColors.iaaiRed : AppColors.copartBlue,
                                  size: 26,
                                ),
                              ),
                              title: Text(
                                query['title'] ?? '',
                                style: TextStyle(
                                  fontFamily: 'CarFinderFont',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                query['criteria'] ?? '',
                                style: TextStyle(
                                  fontFamily: 'CarFinderFont',
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                onPressed: () => _deleteQuery(queryIndex, query),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (screenContext) => SearchScreen(
                                      serviceName: _selectedAuction,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }
}
