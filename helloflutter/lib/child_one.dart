import 'package:flutter/material.dart';

class ChildOne extends StatelessWidget {
  const ChildOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcom in my Flutter App!",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
        ),
        Container(padding: EdgeInsets.all(20)),
      ],
    );
  }
}
