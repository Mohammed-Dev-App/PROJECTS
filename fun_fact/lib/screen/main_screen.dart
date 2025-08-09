import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fun_fact/screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> fun_fact = [];
  bool isLoading = true;
  Future<void> getData() async {
    try {
      Response response = await Dio().get(
        "https://raw.githubusercontent.com/Mohammed-ave/Flutter_Repositry/refs/heads/main/Facts.json",
      );
      fun_fact = jsonDecode(response.data);
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fun Fact"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsScreen();
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: fun_fact.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                fun_fact[index],
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(child: Text("Swipe left foe more")),
          ),
        ],
      ),
    );
  }
}
