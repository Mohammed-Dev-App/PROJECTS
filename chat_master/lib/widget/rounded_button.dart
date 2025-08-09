import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double hight;
  final double width;
  final Function onPresses;
  RoundedButton({
    super.key,
    required this.name,
    required this.hight,
    required this.width,
    required this.onPresses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hight,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(hight * 0.25),
        color: Color.fromRGBO(0, 82, 218, 1.0),
      ),
      child: TextButton(
        onPressed: () => onPresses(),
        child: Text(
          name,
          style: TextStyle(fontSize: 22, color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}
