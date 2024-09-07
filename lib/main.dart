import 'package:flutter/material.dart';
import 'package:shortest_path_app/screens/calculation_process_screen.dart';
import 'package:shortest_path_app/screens/result_grid_screen.dart';
import 'package:shortest_path_app/screens/results_screen.dart';
import 'package:shortest_path_app/screens/url_input_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shortest Path App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const UrlInputScreen(),
        '/process': (context) => const CalculationProcessScreen(
              apiUrl: '',
            ),
        '/results': (context) => const ResultListScreen(),
        '/preview': (context) => const ResultGridScreen(field: []),
      },
    );
  }
}
//https://flutter.webspark.dev/flutter/api