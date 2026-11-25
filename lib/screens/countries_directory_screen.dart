import 'package:flutter/material.dart';
import 'web_view_screen.dart';

class CountriesDirectoryScreen extends StatelessWidget {
  const CountriesDirectoryScreen({super.key});

  static const List<Map<String, dynamic>> _countryCatalog = [
    {
      'country': 'США',
      'sites': ['Copart', 'IAAI', 'Manheim', 'CarGurus'],
    },
    {
      'country': 'Канада',
      'sites': ['Copart Canada', 'Impact Auto', 'AutoTrader.ca'],
    },
    {
      'country': 'Польща',
      'sites': ['OTOMOTO', 'Allegro', 'OLX Moto'],
    },
    {
      'country': 'Німеччина',
      'sites': ['mobile.de', 'AutoScout24.de', 'Gebrauchtwagen'],
    },
    {
      'country': 'Франція',
      'sites': ['Leboncoin', 'La Centrale', 'ParuVendu'],
    },
    {
      'country': 'Нідерланди',
      'sites': ['Marktplaats', 'AutoTrack', 'Gaspedaal'],
    },
    {
      'country': 'Швеція',
      'sites': ['Blocket', 'Kvdcars', 'Bytbil'],
    },
    {
      'country': 'Швейцарія',
      'sites': ['AutoScout24.ch', 'Tutti.ch', 'Ricardo'],
    },
  ];

  String _resolveSiteAddress(String name) {
    switch (name) {
      case 'Copart':
        return 'https://www.copart.com';
      case 'IAAI':
      case 'IA':
        return 'https://www.iaai.com';
      case 'Manheim':
        return 'https://www.manheim.com';
      case 'CarGurus':
        return 'https://www.cargurus.com';
      case 'Copart Canada':
        return 'https://www.copart.ca';
      case 'Impact Auto':
        return 'https://www.impactauto.ca';
      case 'AutoTrader.ca':
        return 'https://www.autotrader.ca';
      case 'OTOMOTO':
        return 'https://www.otomoto.pl';
      case 'Allegro':
        return 'https://allegro.pl';
      case 'OLX Moto':
        return 'https://www.olx.pl/motoryzacja';
      case 'Blocket':
        return 'https://www.blocket.se';
      case 'Kvdcars':
        return 'https://www.kvdcars.com';
      case 'Bytbil':
        return 'https://www.bytbil.com';
      case 'AutoScout24.ch':
        return 'https://www.autoscout24.ch';
      case 'Tutti.ch':
        return 'https://www.tutti.ch';
      case 'Ricardo':
        return 'https://www.ricardo.ch';
      case 'Leboncoin':
        return 'https://www.leboncoin.fr';
      case 'La Centrale':
        return 'https://www.lacentrale.fr';
      case 'ParuVendu':
        return 'https://www.paruvendu.fr';
      case 'Marktplaats':
        return 'https://www.marktplaats.nl';
      case 'AutoTrack':
        return 'https://www.autotrack.nl';
      case 'Gaspedaal':
        return 'https://www.gaspedaal.nl';
      case 'mobile.de':
        return 'https://www.mobile.de';
      case 'AutoScout24.de':
        return 'https://www.autoscout24.de';
      case 'Gebrauchtwagen':
        return 'https://www.gebrauchtwagen.de';
      default:
        return 'https://www.google.com/search?q=$name+auto';
    }
  }

  Widget _buildFlag2D(String countryName) {
    switch (countryName) {
      case 'США':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            width: 26,
            height: 18,
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: List.generate(
                    5,
                    (stripeIndex) => Expanded(
                      child: Container(
                        color: stripeIndex.isEven ? const Color(0xFFB22234) : Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  width: 11,
                  height: 10,
                  child: Container(color: const Color(0xFF3C3B6E)),
                ),
              ],
            ),
          ),
        );
      case 'Канада':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            width: 26,
            height: 18,
            color: Colors.white,
            child: Row(
              children: [
                Container(width: 7, color: const Color(0xFFFF0000)),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF0000),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Container(width: 7, color: const Color(0xFFFF0000)),
              ],
            ),
          ),
        );
      case 'Польща':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: 26,
            height: 18,
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: const Color(0xFFDC143C))),
              ],
            ),
          ),
        );
      case 'Німеччина':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: 26,
            height: 18,
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.black)),
                Expanded(child: Container(color: const Color(0xFFFF0000))),
                Expanded(child: Container(color: const Color(0xFFFFCC00))),
              ],
            ),
          ),
        );
      case 'Франція':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: 26,
            height: 18,
            child: Row(
              children: [
                Expanded(child: Container(color: const Color(0xFF0055A4))),
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: const Color(0xFFEF4135))),
              ],
            ),
          ),
        );
      case 'Нідерланди':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: 26,
            height: 18,
            child: Column(
              children: [
                Expanded(child: Container(color: const Color(0xFFC8102E))),
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: const Color(0xFF003882))),
              ],
            ),
          ),
        );
      case 'Швеція':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            width: 26,
            height: 18,
            color: const Color(0xFF006AA7),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 3, color: const Color(0xFFFECC00)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 7.5,
                  child: Container(height: 3, color: const Color(0xFFFECC00)),
                ),
              ],
            ),
          ),
        );
      case 'Швейцарія':
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            width: 26,
            height: 18,
            color: const Color(0xFFDA291C),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 10, height: 3, color: Colors.white),
                  Container(width: 3, height: 10, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      default:
        return Container(
          width: 26,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Icon(Icons.language, size: 14, color: Colors.white),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
          children: [
            Text(
              'Країни\nта сайти',
              style: TextStyle(
                fontFamily: 'CarFinderFont',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Оберіть країну для пошуку авто',
              style: TextStyle(
                fontFamily: 'CarFinderFont',
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            ..._countryCatalog.map((countryRecord) {
              final countryTitle = countryRecord['country'] as String;
              final sitesList = countryRecord['sites'] as List<String>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildFlag2D(countryTitle),
                        const SizedBox(width: 10),
                        Text(
                          countryTitle,
                          style: TextStyle(
                            fontFamily: 'CarFinderFont',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sitesList.map((siteName) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (screenContext) => WebViewScreen(
                                  siteName: siteName,
                                  siteAddress: _resolveSiteAddress(siteName),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF161616) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  siteName,
                                  style: TextStyle(
                                    fontFamily: 'CarFinderFont',
                                    fontSize: 13,
                                    color: isDark ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_outward,
                                  size: 12,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: isDark ? Colors.white10 : Colors.black12,
                      height: 1,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
