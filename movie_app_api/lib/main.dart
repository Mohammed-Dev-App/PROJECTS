import 'package:flutter/material.dart';

import 'package:movie_app_api/widget/splash_screen.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie App",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          actionsIconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
