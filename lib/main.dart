import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Importa a tela inicial do seu app

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de DEBUG
      title: 'Coma Bem',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF055442)),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Abre a Splash Screen primeiro
    );
  }
}
