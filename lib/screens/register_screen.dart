import 'package:flutter/material.dart';
import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _secretWordController = TextEditingController();
  final _confirmSecretWordController = TextEditingController();

  bool _obscureSecretWord = true;
  bool _obscureConfirmSecretWord = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _birthDateController.dispose();
    _emailAddressController.dispose();
    _secretWordController.dispose();
    _confirmSecretWordController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      final registeredName = _userNameController.text.trim();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (screenContext) => MainNavigationScreen(
            username: registeredName,
          ),
        ),
      );
    }
  }

  Future<void> _selectBirthDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final formattedDay = pickedDate.day.toString().padLeft(2, '0');
      final formattedMonth = pickedDate.month.toString().padLeft(2, '0');
      final formattedYear = pickedDate.year.toString();
      setState(() {
        _birthDateController.text = '$formattedDay.$formattedMonth.$formattedYear';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація в CarFinder'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add_alt_1,
                size: 64,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'Створіть обліковий запис для участі в автоаукціонах',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'Імʼя користувача',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (fieldContent) {
                  if (fieldContent == null || fieldContent.trim().isEmpty) {
                    return 'Введіть імʼя користувача';
                  }
                  if (fieldContent.trim().length < 3) {
                    return 'Імʼя повинно містити щонайменше 3 символи';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                onTap: _selectBirthDate,
                decoration: InputDecoration(
                  labelText: 'Дата народження (ДД.ММ.РРРР)',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: _selectBirthDate,
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (fieldContent) {
                  if (fieldContent == null || fieldContent.trim().isEmpty) {
                    return 'Оберіть дату народження';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailAddressController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Електронна пошта (Email)',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (fieldContent) {
                  if (fieldContent == null || fieldContent.trim().isEmpty) {
                    return 'Введіть email';
                  }
                  if (!fieldContent.contains('@') || !fieldContent.contains('.')) {
                    return 'Введіть коректний email (наприклад user@mail.com)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _secretWordController,
                obscureText: _obscureSecretWord,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSecretWord ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureSecretWord = !_obscureSecretWord;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (fieldContent) {
                  if (fieldContent == null || fieldContent.isEmpty) {
                    return 'Введіть пароль';
                  }
                  if (fieldContent.length < 6) {
                    return 'Пароль повинен містити не менше 6 символів';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmSecretWordController,
                obscureText: _obscureConfirmSecretWord,
                decoration: InputDecoration(
                  labelText: 'Підтвердження пароля',
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmSecretWord ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmSecretWord = !_obscureConfirmSecretWord;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (fieldContent) {
                  if (fieldContent == null || fieldContent.isEmpty) {
                    return 'Підтвердіть пароль';
                  }
                  if (fieldContent != _secretWordController.text) {
                    return 'Паролі не збігаються';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _submitRegistration,
                child: const Text(
                  'Зареєструватися',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
