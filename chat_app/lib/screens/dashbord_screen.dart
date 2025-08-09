import 'package:chat_app/providers/userprovider.dart';
import 'package:chat_app/screens/addfrined.dart';
import 'package:chat_app/screens/change_name.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/get_list_frind.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  var usId = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  List<String> myfrindId = [];
  List<Map<String, dynamic>> chatlist = [];
  List<String> chatlistIds = [];
  var scaffoldkey = GlobalKey<ScaffoldState>();
  List<String> frindname = [];
  List<String> desc = [];
  var previosdata;

  Future<void> getChatRoom() async {
    // await db.collection("Chatrooms").get().then((datasnapshot) {
    //   for (var singaldata in datasnapshot.docs) {
    //     chatlist.add(singaldata.data());
    //     chatlistIds.add(singaldata.id.toString());
    //   }
    //   setState(() {});
    // });

    try {
      var friendList = await db.collection('frindslist').doc(usId!.uid).get();
      //myfrindId = myfrindId.add(friendList.data());
      myfrindId = List<String>.from(friendList.data()?['frindlist']);
      print(friendList.data()?['frindlist']);
    } catch (e) {
      print(e);
      print("There found error");
    }
    var friendDoc = await db.collection('frinds').doc(usId!.uid).get();
    for (String value in myfrindId) {
      if (friendDoc.exists) {
        print(friendDoc.data());
        frindname.add(friendDoc.data()?[value]['name']);
        var messages = friendDoc.data()?[value]['messages'];

        if (messages != null && messages.isNotEmpty) {
          desc.add(friendDoc.data()?[value]['messages'][0]['content']);
        } else {
          desc.add(" ");
        }

        setState(() {});
      } else {
        print("not found");
      }
    }
  }

  Future<void> getName(id) async {
    try {
      var friendDoc = await db.collection('frinds').doc(usId!.uid).get();
      for (String value in myfrindId) {
        if (friendDoc.exists) {
          print(friendDoc.data());
          if (!frindname.contains(friendDoc.data()?[value]['name'])) {
            frindname.add(friendDoc.data()?[value]['name']);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = Provider.of<Userprovider>(context);
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Chat room"),
        leading: InkWell(
          onTap: () {
            scaffoldkey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(child: Text(userprovider.userName[0])),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              userprovider.screenMode();

              print(userprovider.isDarkMode); //!userprovider.isDarkMode;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  userprovider.isDarkMode
                      ? Icon(Icons.dark_mode)
                      : Icon(Icons.light_mode),
            ),
          ),
        ],
      ),
      // resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              ListTile(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreen();
                      },
                    ),
                  );
                },
                title: Text(
                  userprovider.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userprovider.userEmail),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Text(userprovider.userName[0]),
                ),
              ),
              ListTile(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreen();
                      },
                    ),
                  );
                },
                title: Text("Profile"),
                leading: Icon(Icons.people),
              ),

              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SplashScreen();
                      },
                    ),
                    (route) {
                      return false;
                    },
                  );
                },
                title: Text("Logout"),
                leading: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
      body: GetListFrind(),
      // body: StreamBuilder(
      //   stream: db.collection("frindslist").doc(usId!.uid).snapshots(),
      //   builder: (context, snapshot) {
      //     try {
      //       print(snapshot.data);
      //     } catch (e) {
      //       print("There found an error");
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error '));
      //     } else if ((!snapshot.hasData || !snapshot.data!.exists)) {
      //       return Center(child: Text('No message'));
      //     } else if (snapshot.hasData &&
      //         snapshot.data!.exists &&
      //         snapshot.data!.data() != null &&
      //         snapshot.data != previosdata) {
      //       previosdata = snapshot.data;
      //       print(snapshot.data);
      //       print("there data found  ${snapshot.data}");

      //       final data = previosdata.data() as Map<String, dynamic>;
      //       myfrindId = List<String>.from(data['frindlist'] ?? []);
      //       print("This value For myfrindid = $myfrindId");
      //       return FutureBuilder(
      //         future: db.collection('frinds').doc(usId!.uid).get(),
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Center(child: CircularProgressIndicator());
      //           } else if ((!snapshot.hasData || !snapshot.data!.exists)) {
      //             return Center(child: Text('No Data check your connectin'));
      //           } else if (snapshot.hasData &&
      //               snapshot.data!.exists &&
      //               snapshot.data!.data() != null) {
      //             for (String value in myfrindId) {
      //               if (snapshot.data!.exists) {
      //                 print(snapshot.data!);
      //                 if (!frindname.contains(snapshot.data!?[value]['name'])) {
      //                   frindname.add(snapshot.data!?[value]['name']);
      //                   print(snapshot.data);
      //                 }
      //               }
      //             }

      //             return ListView.builder(
      //               itemCount: myfrindId.length,
      //               itemBuilder: (BuildContext context, int index) {
      //                 String chatroomName = frindname[index] ?? " ";
      //                 return ListTile(
      //                   onTap: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) {
      //                           return ChatRoomScreen(
      //                             senderName: userprovider.userName,
      //                             chatroomName: frindname[index],
      //                             sender_id: usId!.uid,
      //                             received_id: myfrindId[index],
      //                           );
      //                         },
      //                       ),
      //                     );
      //                   },
      //                   trailing: InkWell(
      //                     onTap: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) {
      //                             return ChangeName(
      //                               sender_id: userprovider.userId,
      //                               receivied_id: myfrindId[index],
      //                             );
      //                           },
      //                         ),
      //                       );
      //                     },
      //                     child: Icon(Icons.edit),
      //                   ),
      //                   leading: CircleAvatar(
      //                     child: Text(
      //                       frindname[index][0],
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                     backgroundColor: Colors.deepPurpleAccent,
      //                   ),
      //                   title: Text(
      //                     frindname[index],
      //                     // style: TextStyle(color: Colors.black),
      //                   ),
      //                   subtitle: Text("desc[index]"),
      //                 );
      //               },
      //             );
      //           }
      //           return Center(child: CircularProgressIndicator());
      //         },
      //       );
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // ),
      // GetListFrind(id: userprovider.userId.toString()),
      // body: ListView.builder(
      //   itemCount: frindname.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     String chatroomName = frindname[index];
      //     return ListTile(
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) {
      //               return ChatRoomScreen(
      //                 senderName: userprovider.userName,
      //                 chatroomName: frindname[index],
      //                 sender_id: usId!.uid,
      //                 received_id: myfrindId[index],
      //               );
      //             },
      //           ),
      //         );
      //       },
      //       trailing: InkWell(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) {
      //                 return ChangeName(
      //                   sender_id: usId!.uid,
      //                   receivied_id: myfrindId[index],
      //                 );
      //               },
      //             ),
      //           );
      //         },
      //         child: Icon(Icons.edit),
      //       ),
      //       leading: CircleAvatar(
      //         child: Text(
      //           frindname[index][0],
      //           style: TextStyle(color: Colors.black),
      //         ),
      //         backgroundColor: Colors.deepPurpleAccent,
      //       ),
      //       title: Text(
      //         frindname[index],
      //         // style: TextStyle(color: Colors.black),
      //       ),
      //       subtitle: Text(desc[index]),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // try {
          //   // تأكد من تسجيل دخول المستخدم
          //   User? user = FirebaseAuth.instance.currentUser;

          //   print(usId!.uid);
          //   if (user != null) {
          //     await user.delete();
          //     print(
          //       'تم حذف المستخدم بنجاح: ${Provider.of<Userprovider>(context, listen: false).userId}',
          //     );
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return LoginScreen();
          //         },
          //       ),
          //     );
          //   } else {
          //     print('المستخدم غير مسجل الدخول أو المعرف غير صحيح');
          //   }
          // } catch (e) {
          //   print('فشل حذف المستخدم: $e');
          // }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Addfrined();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
