import 'package:flutter/material.dart';
import '../services/app_storage_service.dart';
import '../theme/app_colors.dart';
import 'car_lot_screen.dart';

class SearchScreen extends StatefulWidget {
  final String serviceName;

  const SearchScreen({
    super.key,
    this.serviceName = 'Copart',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _activeTabIndex = 0;
  String _selectedVehicleType = 'AUTOMOBILE';
  String _selectedYear = '2014 - 2025';
  String _selectedMake = 'TESLA';
  String _selectedModel = 'MODEL 3';
  String _selectedLocation = 'ANY';

  Widget _buildFilterRow(String label, String valueText, VoidCallback onTapAction) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade900),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'CarFinderFont',
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  valueText,
                  style: const TextStyle(
                    fontFamily: 'CarFinderFont',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: Text('${widget.serviceName} Search'),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _activeTabIndex == 0 ? AppColors.copartBlue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Vehicle Finder',
                        style: TextStyle(
                          fontFamily: 'CarFinderFont',
                          color: _activeTabIndex == 0 ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _activeTabIndex == 1 ? AppColors.copartBlue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Quick Picks',
                        style: TextStyle(
                          fontFamily: 'CarFinderFont',
                          color: _activeTabIndex == 1 ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterRow('Vehicle Type', _selectedVehicleType, () {}),
          _buildFilterRow('Year', _selectedYear, () {}),
          _buildFilterRow('Make', _selectedMake, () {}),
          _buildFilterRow('Model', _selectedModel, () {}),
          _buildFilterRow('Location', _selectedLocation, () {}),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.copartBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (screenContext) => const CarLotScreen(
                      carTitle: '2021 TESLA MODEL 3',
                      initialPrice: 8100,
                    ),
                  ),
                );
              },
              child: const Text(
                'Search',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.copartBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final currentSaved = await AppStorageService.loadFavoriteIdentities();
                if (!currentSaved.contains('101')) {
                  currentSaved.add('101');
                  await AppStorageService.saveFavoriteIdentities(currentSaved);
                }
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Пошуковий запит збережено в "Збереження"!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'ЗБЕРЕГТИ',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
