import 'package:flutter/material.dart';
import '../services/app_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'register_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _currentAvatarPath = 'assets/images/avatar.png';
  String _profileEmail = '';

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }

  Future<void> _loadProfileDetails() async {
    final loadedProfile = await AppStorageService.loadUserProfile();
    if (mounted) {
      setState(() {
        _profileEmail = loadedProfile['email'] ?? '';
      });
    }
  }

  void _openGalleryPicker() {
    final avatarChoices = [
      {'title': 'Синій профіль', 'path': 'assets/images/avatar.png'},
      {'title': 'Автодилер', 'path': 'assets/images/avatar_dealer.png'},
      {'title': 'Спорткар', 'path': 'assets/images/avatar_porsche.png'},
      {'title': 'Tesla драйвер', 'path': 'assets/images/avatar_tesla.png'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Оберіть фото профілю з галереї',
                style: AppStyles.title,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: avatarChoices.map((choice) {
                  final assetPath = choice['path']!;
                  final isSelected = _currentAvatarPath == assetPath;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentAvatarPath = assetPath;
                      });
                      Navigator.pop(bottomSheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Фото профілю змінено на "${choice['title']}"'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(assetPath),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          choice['title']!,
                          style: const TextStyle(
                            fontFamily: 'CarFinderFont',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedEmail = _profileEmail.isNotEmpty
        ? _profileEmail
        : '${widget.username}@carfinder.ua';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _openGalleryPicker,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    backgroundImage: AssetImage(_currentAvatarPath),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _openGalleryPicker,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.username,
            style: AppStyles.title,
          ),
          const SizedBox(height: 4),
          Text(
            displayedEmail,
            style: AppStyles.subtitle,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Учасник торгів Copart / Автодилер',
              style: TextStyle(
                fontFamily: 'CarFinderFont',
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: widget.isDarkMode ? AppColors.secondary : AppColors.primary,
                  ),
                  title: const Text('Темна тема', style: AppStyles.body),
                  subtitle: Text(
                    widget.isDarkMode ? 'Нічний режим увімкнено' : 'Денний режим увімкнено',
                    style: AppStyles.subtitle,
                  ),
                  value: widget.isDarkMode,
                  onChanged: (themeEnabled) {
                    widget.onThemeChanged(themeEnabled);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                  title: const Text('Змінити фото з галереї', style: AppStyles.body),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _openGalleryPicker,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/profile.png',
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Мої ставки на аукціоні', style: AppStyles.body),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_none, color: AppColors.primary),
                  title: const Text('Сповіщення про лоти', style: AppStyles.body),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security_outlined, color: AppColors.primary),
                  title: const Text('Безпека акаунту', style: AppStyles.body),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await AppStorageService.clearUserProfile();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (logoutContext) => const RegisterScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Вийти з профілю', style: AppStyles.button),
          ),
        ],
      ),
    );
  }
}
