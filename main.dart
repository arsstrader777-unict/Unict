import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const UnictApp());
}

class UnictApp extends StatelessWidget {
  const UnictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unict MVP',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF3E5F5), // Светло-фиолетовый фон
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _statusText = '';

  // Функция для отправки данных на сервер (Python)
  Future<void> _sendDataToBackend() async {
    final String email = _emailController.text;
    if (email.isEmpty) {
      setState(() { _statusText = 'Введите почту!'; });
      return;
    }

    setState(() { _statusText = 'Отправка на сервер...'; });

    try {
      // ВАЖНО: Если запускаешь локально, тут будет localhost.
      // Если в облаке, замени на URL твоего бэкенда.
      final url = Uri.parse('https://unict-backend.onrender.com/register');
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        setState(() { _statusText = 'Успех! Сервер ответил: ${response.body}'; });
      } else {
        setState(() { _statusText = 'Ошибка сервера: ${response.statusCode}'; });
      }
    } catch (e) {
      setState(() { _statusText = 'Ошибка сети. Сервер запущен?'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Логотип Unict
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pinkAccent],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text('U', style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Unict', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.purple)),
              const SizedBox(height: 40),
              
              // Поле ввода
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Кнопка
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _sendDataToBackend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Get Started', style: TextStyle(fontSize: 18)),
                ),
              ),
              
              const SizedBox(height: 20),
              // Текст статуса (показывает ответ от Python)
              Text(_statusText, style: const TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
