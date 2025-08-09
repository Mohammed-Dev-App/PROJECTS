import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginControler {
  static Future<void> login({
    required BuildContext context,
    required String Email,
    required String Password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email,
        password: Password,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SplashScreen();
          },
        ),
        (route) {
          return false;
        },
      );
    } catch (e) {
      SnackBar messageSnakbar = SnackBar(
        content: Text("Error Invaled Email or password"),
      );
      ScaffoldMessenger.of(context).showSnackBar(messageSnakbar);
      print(e);
    }
  }
}
