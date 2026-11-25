import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_storage_service.dart';
import 'seller_register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accessCodeController = TextEditingController();

  @override
  void dispose() {
    _accessCodeController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      final enteredCode = _accessCodeController.text.trim();
      await AppStorageService.saveUserProfile(
        name: enteredCode,
        email: '$enteredCode@carfinder.ua',
        password: 'secure_access_code',
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (screenContext) => MainNavigationScreen(
            username: enteredCode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                const Text(
                  'Вхід у\nсистему',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Введіть код доступу',
                  style: TextStyle(
                    fontFamily: 'CarFinderFont',
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _accessCodeController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Ваш логін або код',
                    hintStyle: TextStyle(color: Colors.white38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (fieldContent) {
                    if (fieldContent == null || fieldContent.trim().isEmpty) {
                      return 'Будь ласка, введіть код доступу або логін';
                    }
                    if (fieldContent.trim().length < 2) {
                      return 'Мінімум 2 символи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (screenContext) => const SellerRegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Отримати код доступу',
                    style: TextStyle(
                      fontFamily: 'CarFinderFont',
                      fontSize: 13,
                      color: Colors.white60,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitLogin,
                  child: const Text(
                    'Увійти',
                    style: TextStyle(
                      fontFamily: 'CarFinderFont',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
