import 'package:chat_app/providers/userprovider.dart';
import 'package:chat_app/screens/dashbord_screen.dart';

import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (user == null) {
        openLogin();
      } else {
        openDashbord();
        //openLogin();
        // GetListFrind(
        //   id: Provider.of<Userprovider>(context, listen: false).userId,
        // );
      }
    });
    super.initState();
  }

  void openDashbord() {
    Provider.of<Userprovider>(context, listen: false).getDetails();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DashbordScreen();
        },
      ),
    );
  }

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
