import 'package:flutter/material.dart';
import 'package:helloflutter/child_one.dart';
import 'package:helloflutter/child_three.dart';
import 'package:helloflutter/child_tow.dart';

class Thecontiner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      color: Colors.blue[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ChildOne(), ChildTow(), ChildThree()],
      ),
    );
  }
}
