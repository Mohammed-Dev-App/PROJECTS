import 'package:flutter/material.dart';
import 'package:movie_app_api/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        ),
      );
    });
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            "assest/images/logo.png",
            fit: BoxFit.cover,
            height: 200,
          ),
        ),
      ),
    );
  }
}
