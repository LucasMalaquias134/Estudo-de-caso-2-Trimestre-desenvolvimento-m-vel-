import 'package:estudo_de_caso_2_trimestre/splash/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Contatos',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
