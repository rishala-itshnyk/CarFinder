import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/car_lot_model.dart';
import '../services/app_storage_service.dart';
import '../services/native_device_service.dart';
import '../theme/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  final String siteName;
  final String siteAddress;

  const WebViewScreen({
    super.key,
    required this.siteName,
    required this.siteAddress,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkInitialFavorite();
    _startLoadingSimulation();
  }

  Future<void> _checkInitialFavorite() async {
    final savedFavorites = await AppStorageService.loadFavoriteIdentities();
    final webDetails = await NativeDeviceService.fetchCurrentWebDetails();
    final pageAddress = webDetails['address'] ?? '';
    final lotMatch = RegExp(r'/lot/(\d+)').firstMatch(pageAddress);
    final lotIdString = lotMatch != null ? lotMatch.group(1)! : '';
    if (mounted) {
      setState(() {
        _isSaved = savedFavorites.contains(lotIdString);
      });
    }
  }

  Future<void> _startLoadingSimulation() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final webDetails = await NativeDeviceService.fetchCurrentWebDetails();
    final pageAddress = webDetails['address'] ?? '';
    final pageHeading = webDetails['heading'] ?? '';

    final isCopartLot = pageAddress.toLowerCase().contains('/lot/');

    if (!isCopartLot) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Помилка: зберегти можна лише відкриту сторінку конкретного авто (лот Copart)!'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final lotMatch = RegExp(r'/lot/(\d+)').firstMatch(pageAddress);
    final lotIdString = lotMatch != null ? lotMatch.group(1)! : '';
    final lotIdentity = int.tryParse(lotIdString) ?? (DateTime.now().millisecondsSinceEpoch % 1000000);

    String cleanCarTitle = pageHeading;
    if (cleanCarTitle.contains(' for Auction')) {
      cleanCarTitle = cleanCarTitle.split(' for Auction').first.trim();
    } else if (cleanCarTitle.contains(' at Copart')) {
      cleanCarTitle = cleanCarTitle.split(' at Copart').first.trim();
    } else if (cleanCarTitle.contains(' - Copart')) {
      cleanCarTitle = cleanCarTitle.split(' - Copart').first.trim();
    }
    if (cleanCarTitle.isEmpty || cleanCarTitle.toLowerCase() == 'copart') {
      final slugSegments = pageAddress.split('/lot/$lotIdString/');
      if (slugSegments.length > 1 && slugSegments[1].isNotEmpty) {
        cleanCarTitle = slugSegments[1]
            .split('?').first
            .replaceAll('-', ' ')
            .split('/')
            .first
            .trim();
      } else {
        cleanCarTitle = 'Copart Lot $lotIdString';
      }
    }

    final carLotsList = await AppStorageService.loadCarLotsList();
    final savedFavorites = await AppStorageService.loadFavoriteIdentities();
    final finalLotKey = lotIdentity.toString();

    final lotIndex = carLotsList.indexWhere((lot) => lot.id == lotIdentity);

    setState(() {
      _isSaved = !_isSaved;
    });

    if (_isSaved) {
      if (lotIndex >= 0) {
        carLotsList[lotIndex].isFavorite = true;
      } else {
        carLotsList.add(
          CarLotModel(
            id: lotIdentity,
            title: cleanCarTitle,
            price: 0,
            isFavorite: true,
            status: LotStatus.active,
            auction: 'Copart',
          ),
        );
      }
      if (!savedFavorites.contains(finalLotKey)) {
        savedFavorites.add(finalLotKey);
      }
      await AppStorageService.saveCarLotsList(carLotsList);
      await AppStorageService.saveFavoriteIdentities(savedFavorites);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Авто "$cleanCarTitle" (#$lotIdentity) збережено в список!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      if (lotIndex >= 0) {
        carLotsList[lotIndex].isFavorite = false;
      }
      savedFavorites.remove(finalLotKey);
      await AppStorageService.saveCarLotsList(carLotsList);
      await AppStorageService.saveFavoriteIdentities(savedFavorites);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Авто "$cleanCarTitle" вилучено зі збережених'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAndroidDevice = !kIsWeb && Platform.isAndroid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.siteName,
              style: const TextStyle(
                fontFamily: 'CarFinderFont',
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              widget.siteAddress,
              style: const TextStyle(
                fontFamily: 'CarFinderFont',
                fontSize: 10,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.favorite : Icons.favorite_border,
              color: _isSaved ? AppColors.error : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: Colors.white, size: 20),
            onPressed: () => NativeDeviceService.openRealBrowser(widget.siteAddress),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isAndroidDevice)
            AndroidView(
              viewType: 'carfinder/web_platform_view',
              creationParams: <String, dynamic>{
                'url': widget.siteAddress,
              },
              creationParamsCodec: const StandardMessageCodec(),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.language,
                        size: 56,
                        color: AppColors.copartBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.siteName,
                      style: const TextStyle(
                        fontFamily: 'CarFinderFont',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.siteAddress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'CarFinderFont',
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.copartBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => NativeDeviceService.openRealBrowser(widget.siteAddress),
                      icon: const Icon(Icons.open_in_browser),
                      label: Text(
                        'Відкрити ${widget.siteName}',
                        style: const TextStyle(
                          fontFamily: 'CarFinderFont',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                color: AppColors.copartBlue,
                minHeight: 3,
              ),
            ),
        ],
      ),
    );
  }
}
