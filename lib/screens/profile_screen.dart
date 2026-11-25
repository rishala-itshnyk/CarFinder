import 'package:flutter/material.dart';
import '../services/app_storage_service.dart';
import '../services/native_device_service.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

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
  String _profileEmail = '';
  String _profilePhone = '';
  String _profileCity = '';
  String _uploadedDocumentTitle = '';
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
    _loadProfileDetails();
    _syncTheme();
  }

  Future<void> _syncTheme() async {
    final savedTheme = await AppStorageService.loadThemeMode();
    if (mounted && _isDark != savedTheme) {
      setState(() {
        _isDark = savedTheme;
      });
    }
  }

  Future<void> _loadProfileDetails() async {
    final loadedProfile = await AppStorageService.loadUserProfile();
    if (mounted) {
      setState(() {
        _profileEmail = loadedProfile['email'] ?? '${widget.username}@carfinder.ua';
        _profilePhone = loadedProfile['phone'] ?? '+380 67 123 4567';
        _profileCity = loadedProfile['city'] ?? 'Київ';
      });
    }
  }

  Future<void> _openDocumentPicker() async {
    final pickedFile = await NativeDeviceService.pickDocumentFromGallery();
    if (!mounted) return;
    if (pickedFile != null && pickedFile.isNotEmpty) {
      setState(() {
        _uploadedDocumentTitle = pickedFile;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Файл "$pickedFile" обрано з галереї та завантажено!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вибір з галереї скасовано або не обрано файл'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildMinimalRow(String label, String contentText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'CarFinderFont',
              fontSize: 14,
              color: _isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          Text(
            contentText,
            style: TextStyle(
              fontFamily: 'CarFinderFont',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDark ? Colors.black : Colors.white,
        foregroundColor: _isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Профіль\nкористувача',
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _isDark ? Colors.white : Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.username,
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 16,
                  color: _isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _profileEmail,
                style: TextStyle(
                  fontFamily: 'CarFinderFont',
                  fontSize: 13,
                  color: _isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              _buildMinimalRow('Телефон', _profilePhone),
              Divider(color: _isDark ? Colors.white12 : Colors.black12, height: 1),
              _buildMinimalRow('Місто / Регіон', _profileCity),
              Divider(color: _isDark ? Colors.white12 : Colors.black12, height: 1),
              _buildMinimalRow('Підписка', 'PRO активна до 31.12.2026'),
              Divider(color: _isDark ? Colors.white12 : Colors.black12, height: 1),
              _buildMinimalRow(
                'Верифікація',
                _uploadedDocumentTitle.isNotEmpty ? 'Перевіряється' : 'Потрібні документи',
              ),
              Divider(color: _isDark ? Colors.white12 : Colors.black12, height: 1),
              InkWell(
                onTap: _openDocumentPicker,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Завантажити фото документів',
                            style: TextStyle(
                              fontFamily: 'CarFinderFont',
                              fontSize: 14,
                              color: _isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _uploadedDocumentTitle.isNotEmpty
                                ? 'Обрано: $_uploadedDocumentTitle'
                                : 'Вибір з галереї телефону',
                            style: TextStyle(
                              fontFamily: 'CarFinderFont',
                              fontSize: 12,
                              color: _uploadedDocumentTitle.isNotEmpty
                                  ? AppColors.success
                                  : (_isDark ? Colors.white38 : Colors.black45),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: _isDark ? Colors.white38 : Colors.black38,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: _isDark ? Colors.white12 : Colors.black12, height: 1),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Темна тема',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    color: _isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _isDark ? 'Увімкнено чорний стиль' : 'Увімкнено світлий стиль',
                  style: TextStyle(
                    color: _isDark ? Colors.white60 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                value: _isDark,
                activeColor: AppColors.copartBlue,
                onChanged: (themeEnabled) async {
                  setState(() {
                    _isDark = themeEnabled;
                  });
                  widget.onThemeChanged(themeEnabled);
                  await AppStorageService.saveThemeMode(themeEnabled);
                },
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDark ? Colors.white : Colors.black,
                  foregroundColor: _isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await AppStorageService.clearUserProfile();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Вийти з акаунту',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
