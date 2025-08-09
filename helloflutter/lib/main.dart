// ignore_for_file: sort_child_properties_last

//import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Poppins"),

      home: Scaffold(
        appBar: AppBar(
          //toolbarTextStyle:Colors.white ,
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          title: Text(
            "Hello Flutter",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              fontStyle: FontStyle.italic,
            ),
          ),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          // titleTextStyle: Colors.white
        ),

        body: Container(
          // padding: EdgeInsets.all(30),
          //padding: EdgeInsets.only(top: 10, bottom: 10),
          //margin: EdgeInsets.all(20),
          //child: Text("Hello"),
          // height: 100,
          //width: 100,
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          //color: Colors.amberAccent[200],
          decoration: BoxDecoration(
            color: Colors.blue[100],
            //borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            //mainAxisAlignment: MainAxisAlignment.start,

            //mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Welcome to Hello Fluter App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.italic,
                ),
              ),
              Column(
                children: [
                  Image.asset("assets/images/flutter.png", height: 100),
                  // Image.file(
                  //   File('C:/Users/Mohammed/Desktop/Icon-maskable-192.png'),
                  // ),
                  SizedBox(height: 20),
                  Text(
                    "This App is Devloper by Mohammed!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "myfont",
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              Container(
                //  height: 55,
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  //color: Color.fromARGB(238, 50, 49, 49),
                  color: Colors.white,
                  // image: Image.file("")
                ),

                //color: Colors.blue[900],
                alignment: Alignment.center,

                // decoration: BoxDecoration(
                //color: Colors.blue[100],
                //borderRadius: BorderRadius.circular(20),
                //)

                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,

                //   children: [
                //     Container(
                //       padding: EdgeInsets.only(left: 10),
                //       child: Text(
                //         "image",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //     Container(),
                //     Column(
                //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Container(
                //           child: Text(
                //             "1",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //         Container(
                //           child: Text(
                //             "2",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //         Container(
                //           child: Text(
                //             "3",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                child: Container(
                  //color: Colors.white,
                  child: Row(
                    children: [
                      Image.asset("assets/images/R.png", width: 50),
                      //Image.network(URL)
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
                          Text(
                            "www.blabla.com",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                ),
                //color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
