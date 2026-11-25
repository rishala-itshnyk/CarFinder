import 'package:flutter/material.dart';
import '../services/app_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class CarLotScreen extends StatefulWidget {
  final String carTitle;
  final int initialPrice;

  const CarLotScreen({
    super.key,
    this.carTitle = '2021 TESLA MODEL 3',
    this.initialPrice = 8100,
  });

  @override
  State<CarLotScreen> createState() => _CarLotScreenState();
}

class _CarLotScreenState extends State<CarLotScreen> {
  int _currentImageIndex = 0;
  late int _bidAmount;
  bool _isSaved = false;

  final List<String> _carPhotos = [
    'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1566939901549-47e37fad4f9a?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1572191267337-c1705e46645c?auto=format&fit=crop&w=1000&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _bidAmount = widget.initialPrice;
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    final savedIds = await AppStorageService.loadFavoriteIdentities();
    if (mounted) {
      setState(() {
        _isSaved = savedIds.contains('101');
      });
    }
  }

  Future<void> _toggleSave() async {
    final savedIds = await AppStorageService.loadFavoriteIdentities();
    setState(() {
      _isSaved = !_isSaved;
    });

    if (_isSaved) {
      if (!savedIds.contains('101')) savedIds.add('101');
    } else {
      savedIds.remove('101');
    }

    await AppStorageService.saveFavoriteIdentities(savedIds);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? 'Лот збережено в обране!' : 'Лот вилучено з обраного'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildSpecLine(String title, String valueText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'CarFinderFont',
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          Text(
            valueText,
            style: const TextStyle(
              fontFamily: 'CarFinderFont',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: () {
                setState(() {
                  _currentImageIndex = (_currentImageIndex - 1 + _carPhotos.length) % _carPhotos.length;
                });
              },
            ),
            const Text(
              '7 of 1,795',
              style: TextStyle(
                fontFamily: 'CarFinderFont',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: () {
                setState(() {
                  _currentImageIndex = (_currentImageIndex + 1) % _carPhotos.length;
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  color: Colors.black,
                  child: Image.network(
                    _carPhotos[_currentImageIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (context, errorObject, stackTrace) {
                      return Container(
                        color: Colors.blueGrey.shade900,
                        alignment: Alignment.center,
                        child: const Icon(Icons.directions_car, size: 80, color: Colors.white38),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 14, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _currentImageIndex = (_currentImageIndex - 1 + _carPhotos.length) % _carPhotos.length;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _currentImageIndex = (_currentImageIndex + 1) % _carPhotos.length;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_carPhotos.length, (photoIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 48,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentImageIndex == photoIndex ? AppColors.copartBlue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      _carPhotos[photoIndex],
                      fit: BoxFit.cover,
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.carTitle,
                        style: const TextStyle(
                          fontFamily: 'CarFinderFont',
                          color: AppColors.copartBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isSaved ? Icons.favorite : Icons.favorite_border,
                          color: _isSaved ? AppColors.error : Colors.white70,
                        ),
                        onPressed: _toggleSave,
                      ),
                    ],
                  ),
                  const Text(
                    'Lot # 59172804 | COPART',
                    style: TextStyle(
                      fontFamily: 'CarFinderFont',
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildSpecLine('Sale Date:', '11/11/2024'),
                        _buildSpecLine('Sale Time:', '11:00 PM EET'),
                        _buildSpecLine('Est. Retail Value:', '\$27,807.52'),
                        _buildSpecLine('Odometer:', '52,451 mi (ACTUAL)'),
                        _buildSpecLine('Damage:', 'Front End'),
                        _buildSpecLine('Status:', 'Run & Drive'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF1E1E1E),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Bid:',
                      style: TextStyle(
                        fontFamily: 'CarFinderFont',
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '\$$_bidAmount',
                      style: const TextStyle(
                        fontFamily: 'CarFinderFont',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.copartBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _toggleSave,
                child: Text(
                  _isSaved ? 'ЗБЕРЕЖЕНО' : 'ЗБЕРЕГТИ',
                  style: const TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
