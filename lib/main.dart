import 'package:flutter/material.dart';

void main() {
  runApp(const ApartmentRepairApp());
}

class ApartmentRepairApp extends StatelessWidget {
  const ApartmentRepairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apartment Repair Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const RepairHomePage(title: 'Планувальник Ремонту Квартири'),
    );
  }
}

class RepairHomePage extends StatelessWidget {
  const RepairHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Ласкаво просимо до планувальника ремонту!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Виведення підключеного локального зображення
              Image.asset(
                'assets/photo.jpg',
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'тут будуть ваші етапи робіт, кошторис та матеріали.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}