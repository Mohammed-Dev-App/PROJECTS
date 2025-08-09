import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200),
            Text(
              "(┬┬﹏┬┬)",
              style: TextStyle(color: Colors.blueAccent, fontSize: 68),
            ),
            Text(
              "Sorry this Page is not implemented",
              style: TextStyle(color: Colors.blueAccent, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
