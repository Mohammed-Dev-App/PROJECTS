import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DummyChild extends StatelessWidget {
  String name;
  DummyChild({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello $name');
  }
}
