import 'package:flutter/material.dart';
import 'package:shortest_path_app/screens/process_screen.dart';

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
      setState(() {
        errorMessage = null;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProcessScreen(apiUrl: url),
        ),
      );
    } else {
      setState(() {
        errorMessage = 'Некоректний URL';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 245, 245),
      appBar: AppBar(
        title: const Text(
          'Home screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
        shadowColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set valid API base URL in order to continue',
              style: TextStyle(fontSize: 17, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.compare_arrows, color: Colors.grey),
                const SizedBox(width: 25),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText:
                          'https://1e9d-134-249-136-43.ngrok.io/flutter-tutorial',
                      labelStyle: const TextStyle(color: Colors.black87),
                      errorText: errorMessage,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startProcess,
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
                  'Start counting process',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
