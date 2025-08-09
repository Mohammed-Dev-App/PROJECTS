import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/providers/prov_new.dart';
import 'package:chat_app/providers/userprovider.dart';
import 'package:chat_app/screens/change_name.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetListFrind extends StatefulWidget {
  GetListFrind({super.key});

  @override
  State<GetListFrind> createState() => _GetListFrindState();
}

class _GetListFrindState extends State<GetListFrind> {
  var usId = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  List<String> myfrindId = [];
  List<String> frindname = [];
  String desc = " ";
  bool isFound = true;
  Timer? time;
  var previosdata;

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: db.collection("frindslist").doc(usId!.uid).snapshots(),
        builder: (context, snapshot) {
          try {
            print(snapshot.data);
          } catch (e) {
            print("There found an error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error '));
          } else if ((!snapshot.hasData || !snapshot.data!.exists)) {
            return Center(child: Text('No message'));
          } else if (snapshot.hasData &&
              snapshot.data!.exists &&
              snapshot.data!.data() != null &&
              snapshot.data != previosdata) {
            previosdata = snapshot.data;
            print(snapshot.data);
            print("there data found  ${snapshot.data}");

            final data = previosdata.data() as Map<String, dynamic>;
            myfrindId = List<String>.from(data['frindlist'] ?? []);
            print("This value For myfrindid = $myfrindId");

            return FutureBuilder(
              future: db.collection('frinds').doc(usId!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if ((!snapshot.hasData || !snapshot.data!.exists)) {
                  return Center(child: Text('No Data check your connectin'));
                } else if (snapshot.hasData &&
                    snapshot.data!.exists &&
                    snapshot.data!.data() != null) {
                  for (String value in myfrindId) {
                    if (snapshot.data!.exists) {
                      print(snapshot.data!);
                      if (!frindname.contains(snapshot.data!?[value]['name'])) {
                        frindname.add(snapshot.data!?[value]['name']);
                        print(snapshot.data);
                      }
                    }
                  }

                  return ListView.builder(
                    itemCount: myfrindId.length,
                    itemBuilder: (BuildContext context, int index) {
                      String chatroomName = frindname[index] ?? " ";
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatRoomScreen(
                                  senderName: userprovider.userName,
                                  chatroomName: frindname[index],
                                  sender_id: usId!.uid,
                                  received_id: myfrindId[index],
                                );
                              },
                            ),
                          );
                        },
                        trailing: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChangeName(
                                    sender_id: userprovider.userId,
                                    receivied_id: myfrindId[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: Icon(Icons.edit),
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            frindname[index][0],
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                        title: Text(
                          frindname[index],
                          // style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text("desc[index]"),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
