import 'package:flutter/material.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Перевіряємо чи отримали аргументи
    final results = ModalRoute.of(context)!.settings.arguments as List<String>?;

    if (results == null || results.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result list screen')),
        body: const Center(
          child: Text('No results to display'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Card(
            child: ListTile(
              title: Text(result),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultDetailScreen(result: result),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ResultDetailScreen extends StatelessWidget {
  final String result;

  const ResultDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result detail'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Details about the result: $result',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
