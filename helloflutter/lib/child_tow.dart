import 'package:flutter/material.dart';

class ChildTow extends StatelessWidget {
  const ChildTow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/images/flutter.png", height: 100),
        SizedBox(height: 20),
        Text(
          "This Flutter is devloped by Mohammed",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
