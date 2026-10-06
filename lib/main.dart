import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const ApartmentRepairPlannerApp());
}

class ApartmentRepairPlannerApp extends StatelessWidget {
  const ApartmentRepairPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apartment Repair Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.ink,
          primary: AppColors.ink,
          secondary: AppColors.accent,
        ),
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
    );
  }
}