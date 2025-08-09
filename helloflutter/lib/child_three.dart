import 'package:flutter/material.dart';

class ChildThree extends StatelessWidget {
  const ChildThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/R.png", height: 50),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mohammed",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Flutter Devloper INFO",
                style: TextStyle(color: Colors.black87),
              ),
              Text("www.blabla.com", style: TextStyle(color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}
