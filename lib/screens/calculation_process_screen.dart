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
  bool isLoading = false;
  String? errorMessage;

  Future<void> _calculate() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(widget.apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          progress = data['progress'];
        });
      } else {
        setState(() {
          errorMessage = 'Помилка отримання даних';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Не вдалося виконати запит';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Процес виконання')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(value: progress)
            : errorMessage != null
                ? Text(errorMessage!)
                : ElevatedButton(
                    onPressed: _calculate,
                    child: const Text('Send results to server'),
                  ),
      ),
    );
  }
}
