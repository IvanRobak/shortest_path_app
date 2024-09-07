import 'package:flutter/material.dart';

class ResultGridScreen extends StatelessWidget {
  final List<List<String>> field;

  const ResultGridScreen({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colorMapping = {
      'start': const Color(0xFF64FFDA),
      'end': const Color(0xFF009688),
      'blocked': const Color(0xFF000000),
      'path': const Color(0xFF4CAF50),
      'empty': const Color(0xFFFFFFFF),
    };

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final List<List<String>> field = arguments['field'];
    final String path = arguments['path'];

    return Scaffold(
      appBar: AppBar(title: const Text('Preview screen')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: field.length * field[0].length,
                itemBuilder: (context, index) {
                  final x = index ~/ field[0].length;
                  final y = index % field[0].length;
                  final cell = field[x][y];

                  Color cellColor =
                      colorMapping[cell] ?? colorMapping['empty']!;

                  return Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: cellColor,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text('($x, $y)'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Шлях: $path', // Виведення шляху
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
