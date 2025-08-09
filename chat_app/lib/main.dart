import 'dart:io';

import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/providers/prov_new.dart';
import 'package:chat_app/providers/userprovider.dart';
import 'package:chat_app/screens/addfrined.dart';
import 'package:chat_app/screens/get_list_frind.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // print("Platform.operatingSystemVersion");
  // print(Platform.operatingSystemVersion);
  // var duration = const Duration(seconds: 5);
  // sleep(duration);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return Userprovider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProvNew();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var main_mode = Provider.of<Userprovider>(context);
    return MaterialApp(
      theme:
          main_mode.isDarkMode
              ? ThemeData(brightness: Brightness.dark, fontFamily: "Poppins")
              : ThemeData(brightness: Brightness.light, fontFamily: "Poppins"),
      home: SplashScreen(),
    );
  }
}
