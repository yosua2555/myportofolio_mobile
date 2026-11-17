import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

/// Titik masuk utama aplikasi MyPortfolio Mobile.
void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi yang mengonfigurasi tema Material 3 dan halaman awal.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}