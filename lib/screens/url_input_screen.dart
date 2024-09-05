import 'package:flutter/material.dart';
import 'package:shortest_path_app/screens/calculation_process_screen.dart';

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  UrlInputScreenState createState() => UrlInputScreenState();
}

class UrlInputScreenState extends State<UrlInputScreen> {
  final TextEditingController _urlController = TextEditingController();
  String? errorMessage;

  void _startProcess() {
    final url = _urlController.text;
    if (Uri.tryParse(url)?.hasAbsolutePath == true) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CalculationProcessScreen(apiUrl: url)));
    } else {
      setState(() {
        errorMessage = 'Некоректний URL';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Введення URL')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Введіть API URL',
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startProcess,
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
