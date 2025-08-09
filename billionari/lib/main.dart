import 'package:billionari/Add_Monye_Button.dart';
import 'package:billionari/balance_part.dart';
import 'package:billionari/dummy_child.dart';
import 'package:billionari/shared_preferences/lib/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

// StatelessWidget maens cannot change any thing ,So if you need to change a component use statefullwidegt
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

double balance = 0.0;

class _MyAppState extends State<MyApp> {
  void buttonFunction() async {
    final prefs = await SharedPreferences.getInstance();

    //  getData();
    //getData('balance');
    //getData();
    setState(() {
      //print("Button is click");
      balance++;
      prefs.setDouble('balance', balance);
    });
    //getData();

    // Obtain shared preferences.
    //final SharedPreferences prefs = await SharedPreferences.getInstance();

    // // Save an integer value to 'counter' key.
    // await prefs.setInt('counter', 10);
    // // Save an boolean value to 'repeat' key.
    // await prefs.setBool('repeat', true);
    // // Save an double value to 'decimal' key.
    // await prefs.setDouble('balance', balance);
    // // Save an String value to 'action' key.
    // await prefs.setString('action', 'Start');
    // // Save an list of strings to 'items' key.
    // await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      balance = prefs.getDouble('balance') ?? 0.0;
    });
  }

  // any package will find INFO about in pubspec.yaml
  // to save data localy you need to install package  shared prefrence the command used flutter pub add shared_preferences
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Billionari App!")),
        body: Container(
          color: Colors.blueGrey[700],
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              BalancePart(balance: balance),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // Container(
              //     //   width: double.infinity,
              //     //   color: Colors.red,
              //     //   child: Text("1"),
              //     // ),
              //     // Container(color: Colors.green, child: Text("1")),
              //     // Container(color: Colors.blue, child: Text("1")),
              //     Expanded(
              //       flex: 2,
              //       child: Container(
              //         width: double.infinity,
              //         color: Colors.red,
              //         child: Text("1"),
              //       ),
              //     ),
              //     Expanded(flex: 1,
              //       child: Container(color: Colors.green, child: Text("2")),
              //     ),

              //     Expanded(flex: 1,
              //       child: Container(color: Colors.blue, child: Text("1")),
              //     ),
              //   ],
              // ),
              //Expanded(
              //child:getData('balance');
              AddMonyeButton(AddMonyeFunction: buttonFunction),
              //),

              //TextButton(onPressed: buttonFunction, child: Text("Click here")),
            ],
          ),
        ),
      ),
    );
  }
}
