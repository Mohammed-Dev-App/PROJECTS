import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddMonyeButton extends StatelessWidget {
  void Function() AddMonyeFunction;

  AddMonyeButton({super.key, required this.AddMonyeFunction});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        //color: Colors.red,
        // width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            minimumSize: Size(double.infinity, 0),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: AddMonyeFunction,
          child: Text("Add Money"),
        ),
      ),
    );
  }
}
