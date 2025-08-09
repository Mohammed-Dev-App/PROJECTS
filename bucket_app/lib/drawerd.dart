import 'package:flutter/material.dart';

class DrawerD extends StatefulWidget {
  const DrawerD({super.key});

  @override
  State<DrawerD> createState() => _DrawerState();
}

class _DrawerState extends State<DrawerD> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.blueGrey[200],
            child: Center(
              child: Text("DrawerD", style: TextStyle(color: Colors.white)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.scuba_diving),
            title: Text(
              "Sky Diving",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          ListTile(
            leading: Icon(Icons.wallet_travel),
            title: Text(
              "Visit Nebal",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
