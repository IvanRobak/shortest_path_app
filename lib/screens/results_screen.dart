import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> results = [
    '(1.2) -> (2.1) -> (2.0)',
    '(0.1) -> (1.2) -> (2.0)',
  ];

  ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Результати')),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index]),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ResultDetailScreen(result: results[index])));
            },
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
      appBar: AppBar(title: const Text('Детальний результат')),
      body: Center(
        child: Text('Шлях: $result'),
      ),
    );
  }
}
