import 'package:flutter/material.dart';
import 'package:jobins_app/templates/dashboards/candidate_dash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobin\'s',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CandidateDashboard(),
    );
  }
}

