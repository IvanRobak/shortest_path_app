import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculationProcessScreen extends StatefulWidget {
  final String apiUrl; // Додаємо параметр apiUrl

  const CalculationProcessScreen({super.key, required this.apiUrl});

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
        Uri.parse(widget.apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          responseData = jsonDecode(response.body);
        });

        // Перевіряємо, чи віджет ще активний і чи є дані
        if (mounted && responseData != null) {
          // Переходимо на екран результатів після успішного отримання даних
          Navigator.of(context).pushNamed(
            '/results',
            arguments: responseData!['results'] ??
                [], // Якщо не null, передаємо результати
          );
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Помилка отримання даних: ${response.statusCode}';
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = 'Не вдалося виконати запит: $error';
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
