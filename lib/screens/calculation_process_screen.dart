import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculationProcessScreen extends StatefulWidget {
  final String apiUrl;

  const CalculationProcessScreen({super.key, required this.apiUrl});

  @override
  CalculationProcessScreenState createState() =>
      CalculationProcessScreenState();
}

class CalculationProcessScreenState extends State<CalculationProcessScreen> {
  double progress = 0.0;
  bool isLoading = true;
  bool isCompleted = false;
  List<String> results = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(widget.apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Логування отриманої відповіді для перевірки
        print("Отримана відповідь від API: $data");

        setState(() {
          // Отримуємо поле `data`, яке є списком результатів
          final resultsData = data['data'] as List<dynamic>;

          // Перетворюємо кожен елемент списку на зручний формат, наприклад, як рядки
          results = resultsData.map((item) {
            final start = item['start'];
            final end = item['end'];
            return 'Початок: (${start['x']}, ${start['y']}), Кінець: (${end['x']}, ${end['y']})';
          }).toList();

          isLoading = false;
          isCompleted = true;
          progress = 100;
        });

        // Додаткове логування результатів
        print("Отримані результати: $results");
      } else {
        setState(() {
          isLoading = false;
          isCompleted = true;
          progress = 100;
        });
        throw Exception('Помилка: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isCompleted = true;
      });
      throw Exception('Не вдалося виконати запит: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Процес виконання'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    isCompleted
                        ? 'All calculations have finished, you can send your results to the server'
                        : 'Calculations in progress...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${progress.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          // Якщо завдання завершені, кнопка надсилання результатів
          if (isCompleted)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Перевіряємо чи є результати і переходимо до екрану результатів
                    if (results.isNotEmpty) {
                      Navigator.of(context).pushNamed(
                        '/results',
                        arguments: results, // передаємо результати
                      );
                    } else {
                      print("Результати відсутні.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 120, 187, 241),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 37, 121, 231),
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Send results to server',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
