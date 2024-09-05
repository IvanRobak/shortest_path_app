import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculationProcessScreen extends StatefulWidget {
  final String apiUrl; // Додаємо параметр apiUrl

  const CalculationProcessScreen(
      {super.key,
      required this.apiUrl}); // Передаємо параметр через конструктор

  @override
  CalculationProcessScreenState createState() =>
      CalculationProcessScreenState();
}

class CalculationProcessScreenState extends State<CalculationProcessScreen> {
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? responseData;

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(widget.apiUrl), // Використовуємо переданий apiUrl
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          responseData = jsonDecode(response.body);
        });
        print('Успішно отримано дані: ${response.body}');
      } else {
        setState(() {
          errorMessage = 'Помилка отримання даних: ${response.statusCode}';
        });
        print('HTTP помилка: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Не вдалося виконати запит: $error';
      });
      print('Помилка запиту: $error');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Процес виконання')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Text(errorMessage!)
                : responseData != null
                    ? Text('Дані отримані: ${responseData.toString()}')
                    : ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('Повторити запит'),
                      ),
      ),
    );
  }
}
//https://flutter.webspark.dev/flutter/api