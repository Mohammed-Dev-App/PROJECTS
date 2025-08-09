import 'package:flutter/material.dart';

class ProvNew with ChangeNotifier {
  bool isFound = true;

  void isFoundFrind(bool value) {
    isFound = value;
    notifyListeners();
    print("I am Provider isFound = $isFound");
  }
}
