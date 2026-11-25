import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_storage_service.dart';

class SellerRegisterScreen extends StatefulWidget {
  const SellerRegisterScreen({super.key});

  @override
  State<SellerRegisterScreen> createState() => _SellerRegisterScreenState();
}

class _SellerRegisterScreenState extends State<SellerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sellerNameController = TextEditingController();
  final _sellerPhoneController = TextEditingController();
  final _sellerEmailController = TextEditingController();
  final _sellerCityController = TextEditingController();
  final _verificationSmsController = TextEditingController();

  @override
  void dispose() {
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _sellerEmailController.dispose();
    _sellerCityController.dispose();
    _verificationSmsController.dispose();
    super.dispose();
  }

  void _showSmsVerificationDialog(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Підтвердження',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Введіть код з SMS для $phoneNumber:',
                  style: const TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _verificationSmsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 4),
                  decoration: const InputDecoration(
                    hintText: 'Код з SMS',
                    hintStyle: TextStyle(color: Colors.white38, letterSpacing: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text(
                          'Назад',
                          style: TextStyle(
                            fontFamily: 'CarFinderFont',
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          final registeredName = _sellerNameController.text.trim();
                          final registeredEmail = _sellerEmailController.text.trim();
                          final registeredPhone = _sellerPhoneController.text.trim();
                          final registeredCity = _sellerCityController.text.trim();

                          await AppStorageService.saveUserProfile(
                            name: registeredName,
                            email: registeredEmail,
                            password: 'seller_verified',
                            phone: registeredPhone,
                            city: registeredCity,
                          );

                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (screenContext) => MainNavigationScreen(
                                username: registeredName,
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Увійти',
                          style: TextStyle(
                            fontFamily: 'CarFinderFont',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      _showSmsVerificationDialog(_sellerPhoneController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Реєстрація\nпродавця',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Введіть дані продавця для доступу до торгів',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _sellerNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'ПІБ продавця або назва компанії',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (fieldContent) {
                    if (fieldContent == null || fieldContent.trim().isEmpty) {
                      return 'Введіть імʼя або назву компанії';
                    }
                    if (fieldContent.trim().length < 3) {
                      return 'Мінімум 3 символи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _sellerPhoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Український телефон (+380XXXXXXXXX)',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (fieldContent) {
                    if (fieldContent == null || fieldContent.trim().isEmpty) {
                      return 'Введіть номер телефону';
                    }
                    final trimmed = fieldContent.trim().replaceAll(' ', '').replaceAll('-', '');
                    final ukrainianPhoneRegex = RegExp(r'^(\+?380|0)\d{9}$');
                    if (!ukrainianPhoneRegex.hasMatch(trimmed)) {
                      return 'Номер має бути українським (+380XXXXXXXXX або 0XXXXXXXXX)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _sellerEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Електронна пошта (Email)',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (fieldContent) {
                    if (fieldContent == null || fieldContent.trim().isEmpty) {
                      return 'Введіть email';
                    }
                    if (!fieldContent.contains('@') || !fieldContent.contains('.')) {
                      return 'Введіть коректний email (наприклад seller@auto.ua)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _sellerCityController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Місто / Регіон майданчика',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (fieldContent) {
                    if (fieldContent == null || fieldContent.trim().isEmpty) {
                      return 'Вкажіть місто або регіон';
                    }
                    if (fieldContent.trim().length < 2) {
                      return 'Мінімум 2 символи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleRegister,
                  child: const Text(
                    'Зареєструватися',
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
      ),
    );
  }
}
