import 'package:flutter/material.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = ModalRoute.of(context)?.settings.arguments as List<String>?;

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
                Navigator.of(context).pushNamed(
                  '/preview',
                  arguments: {
                    'field': [
                      ['empty', 'empty', 'empty', 'start'],
                      ['path', 'empty', 'empty', 'blocked'],
                      ['path', 'empty', 'end', 'blocked'],
                      ['path', 'empty', 'empty', 'empty'],
                    ], 
                    'path':
                        '(0,3)->(0,2)->(0,1)', 
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}