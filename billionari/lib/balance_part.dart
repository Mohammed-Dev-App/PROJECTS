import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BalancePart extends StatelessWidget {
  double balance;
  BalancePart({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text("Bank balance "),
          SizedBox(height: 20),
          Text(
            "\$ ${NumberFormat.simpleCurrency(name: '').format(balance)}",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          // DummyChild(name: 'Mohammed'),
          // ElevatedButton(
          //   onPressed: getData,
          //   child: Text("load balance"),
          // ),
        ],
      ),
    );
  }
}
