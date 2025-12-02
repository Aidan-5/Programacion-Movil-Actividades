import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/details_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = 'home';
  static const String details = 'details';
  static const String settings = 'settings';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      details: (context) => const DetailsScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
