import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _startCalculations();
  }

  Future<void> _startCalculations() async {
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        progress = i.toDouble();
      });
    }

    setState(() {
      results = [
        '(0,3) -> (0,2) -> (0,1)',
        '(0,3) -> (1,2) -> (2,3)'
      ]; // Зразок результатів
      isLoading = false;
      isCompleted = true;
    });
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
