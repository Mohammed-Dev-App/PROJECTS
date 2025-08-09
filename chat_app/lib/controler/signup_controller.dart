import 'package:chat_app/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupController {
  static Future<void> createAccount({
    required BuildContext context,
    required String Email,
    required String Password,
    required String Name,
    required String Country,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email,
        password: Password,
      );
      var userid = FirebaseAuth.instance.currentUser!.uid;

      var db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        "Name": Name,
        "Country": Country,
        "Email": Email,
        "id": userid,
      };
      Map<String, dynamic> messageToSend = {
        "id": userid,
        "Name": Name,
        "Email": Email,
        "last_letter": "",
      };
      try {
        await db.collection("users").doc(userid.toString()).set(data);
        await db.collection("Chatrooms").add(messageToSend);
        await db.collection("frinds").doc(userid.toString()).set({});
        await db.collection("frindslist").doc(userid.toString()).set({});
      } catch (e) {
        print(e);
      }
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
        content: Text("Error on creating account"),
      );
      ScaffoldMessenger.of(context).showSnackBar(messageSnakbar);
      print(e);
    }
  }
}
