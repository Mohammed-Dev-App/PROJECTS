import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkModeChecked = false;

  void updateMode(bool value) async {
    isDarkModeChecked = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", isDarkModeChecked);
    notifyListeners();
  }

  void loadMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeChecked = prefs.getBool("isDarkMode") ?? true;
    notifyListeners();
  }
}
