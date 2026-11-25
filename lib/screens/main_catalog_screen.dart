import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/app_colors.dart';
import 'auction_services_screen.dart';
import 'countries_directory_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'web_view_screen.dart';

class MainCatalogScreen extends StatelessWidget {
  final String username;

  const MainCatalogScreen({
    super.key,
    this.username = 'Користувач',
  });

  Widget _buildServiceButton({
    required BuildContext context,
    required String title,
    required Color buttonColor,
    required Color textColor,
    required VoidCallback onTapAction,
  }) {
    return GestureDetector(
      onTap: onTapAction,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CarFinderFont',
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            final appState = CarFinderApp.of(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (screenContext) => ProfileScreen(
                  username: username,
                  isDarkMode: appState?.isDarkMode ?? true,
                  onThemeChanged: (themeEnabled) {
                    appState?.toggleTheme(themeEnabled);
                  },
                ),
              ),
            );
          },
        ),
        title: const Text('Головна'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
              children: [
                _buildServiceButton(
                  context: context,
                  title: 'Copart',
                  buttonColor: AppColors.copartBlue,
                  textColor: Colors.white,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const WebViewScreen(
                          siteName: 'Copart',
                          siteAddress: 'https://www.copart.com',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceButton(
                  context: context,
                  title: 'IAAI',
                  buttonColor: AppColors.iaaiRed,
                  textColor: Colors.white,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const WebViewScreen(
                          siteName: 'IAAI',
                          siteAddress: 'https://www.iaai.com',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceButton(
                  context: context,
                  title: 'mobile.de',
                  buttonColor: AppColors.mobileDeOrange,
                  textColor: Colors.white,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const WebViewScreen(
                          siteName: 'mobile.de',
                          siteAddress: 'https://www.mobile.de',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceButton(
                  context: context,
                  title: 'Auto\nScout24',
                  buttonColor: AppColors.autoScoutYellow,
                  textColor: Colors.black,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const WebViewScreen(
                          siteName: 'AutoScout24',
                          siteAddress: 'https://www.autoscout24.com',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceButton(
                  context: context,
                  title: 'OTOMOTO',
                  buttonColor: AppColors.otomotoOrange,
                  textColor: Colors.white,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const WebViewScreen(
                          siteName: 'OTOMOTO',
                          siteAddress: 'https://www.otomoto.pl',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceButton(
                  context: context,
                  title: 'leboncoin',
                  buttonColor: AppColors.leboncoinOrange,
                  textColor: Colors.white,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const WebViewScreen(
                          siteName: 'leboncoin',
                          siteAddress: 'https://www.leboncoin.fr',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (screenContext) => const CountriesDirectoryScreen(),
                  ),
                );
              },
              child: const Text(
                'Більше',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 16,
                  color: AppColors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
