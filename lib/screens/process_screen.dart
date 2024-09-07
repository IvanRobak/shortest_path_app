import 'dart:convert';
import 'dart:async'; // Для таймера
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProcessScreen extends StatefulWidget {
  final String apiUrl;

  const ProcessScreen({super.key, required this.apiUrl});

  @override
  ProcessScreenState createState() => ProcessScreenState();
}

class ProcessScreenState extends State<ProcessScreen> {
  double progress = 0.0;
  bool isLoading = true;
  bool isCompleted = false;
  List<String> results = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCalculations();
  }

  Future<void> _startCalculations() async {
    _startProgressTimer();

    await _fetchDataFromApi();
  }

  void _startProgressTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (progress < 100) {
        setState(() {
          progress += 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final response = await http.get(
        Uri.parse(widget.apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          final resultsData = data['data'] as List<dynamic>;

          // Перетворюємо дані в рядки
          results = resultsData.map((item) {
            final start = item['start'];
            final end = item['end'];
            return 'Початок: (${start['x']}, ${start['y']}), Кінець: (${end['x']}, ${end['y']})';
          }).toList();
        });
      } else {
        throw Exception('Помилка: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Не вдалося виконати запит: $error');
    }

    _timer?.cancel();

    setState(() {
      progress = 100;
      isCompleted = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
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
          if (isCompleted)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/results',
                      arguments: results,
                    );
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
            ),
        ],
      ),
    );
  }
}
