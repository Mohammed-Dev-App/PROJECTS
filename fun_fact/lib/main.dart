import 'package:flutter/material.dart';
import 'package:fun_fact/provider/provider.dart';
import 'package:fun_fact/screen/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return ThemeProvider();
      },
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
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).loadMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModel = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme:
          ThemeModel.isDarkModeChecked ? ThemeData.dark() : ThemeData.light(),
      home: MainScreen(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
