import 'package:chat_master/pages/home_page.dart';
import 'package:chat_master/pages/login_page.dart';

import 'package:chat_master/pages/register_page.dart';
import 'package:chat_master/pages/splash_screen.dart';
import 'package:chat_master/provider/authentication_provider.dart';
import 'package:chat_master/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // await Supabase.initialize(
  //   url: 'https://gxdfwhxnufdqiedcjhhi.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4ZGZ3aHhudWZkcWllZGNqaGhpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTQ0NDA5NiwiZXhwIjoyMDY3MDIwMDk2fQ.VTZWWV96x__KX_KRPitXIKzx01tFJZkMIpE4M6052HQ',
  // );
  runApp(
    SplashScreen(
      onInitializationComplete: () {
        runApp(MyApp());
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: "Chat",
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        //home: Scaffold(body: Scaffold()),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext _context) => LoginPage(),
          '/register': (BuildContext _context) => RegisterPage(),
          '/home': (BuildContext _context) => HomePage(),
        },
      ),
    );
  }
}
