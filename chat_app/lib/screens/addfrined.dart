import 'package:chat_app/providers/userprovider.dart';
import 'package:chat_app/screens/dashbord_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Addfrined extends StatefulWidget {
  const Addfrined({super.key});

  @override
  State<Addfrined> createState() => _AddfrinedState();
}

class _AddfrinedState extends State<Addfrined> {
  var userForm = GlobalKey<FormState>();
  TextEditingController Email = TextEditingController();
  TextEditingController Name = TextEditingController();
  var db = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<void> addFrind() async {
    isLoading = true;
    setState(() {});
    if (Name.text.isEmpty) {
      return;
    }
    var querySnapshot =
        await db
            .collection('users')
            .where('Email', isEqualTo: Email.text)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var time = FieldValue.serverTimestamp();
      DateTime now = DateTime.now();
      var userId = querySnapshot.docs.first.id; // الحصول على معرف المستخدم
      print('User ID: $userId');
      Map<String, dynamic> friendMessenger = {
        "$userId": {'email': Email.text, 'name': Name.text, 'messages': [
          ],
        },
      };
      // Map<String, dynamic> frindList = {'frinds': []};
      try {
        var usId = FirebaseAuth.instance.currentUser;
        db.collection("frindslist").doc(userId).get().then((doc) async {
          if (doc.exists) {
            var array = doc.get("frindlist");
            if (array.contains(usId!.uid.toString())) {
              SnackBar messageSnakbar = SnackBar(
                content: Text("This Account is already exist"),
              );
              ScaffoldMessenger.of(context).showSnackBar(messageSnakbar);
            } else {
              await db
                  .collection("frinds")
                  .doc(usId!.uid)
                  .update(friendMessenger);

              //await db.collection("frindlist").doc(usId!.uid).set(frindList);
              await db.collection("frindslist").doc(usId!.uid).update({
                'frindlist': FieldValue.arrayUnion([userId.toString()]),
              });
              await db.collection("frindslist").doc(userId).update({
                'frindlist': FieldValue.arrayUnion([usId!.uid.toString()]),
              });
              var uId = usId.uid.toString();
              await db.collection("frinds").doc(userId.toString()).update({
                "$uId": {
                  'email': Email.text,
                  'name': 'Anonymous',
                  'messages': [],
                },
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DashbordScreen();
                  },
                ),
              );
            }
          }
        });

        // Email.text = "";
        // Name.text = "";
        print(now.toString());

        isLoading = false;
        setState(() {});
      } catch (e) {
        isLoading = false;
        print("The error id $e");
        print(e);
      }
    } else {
      print('المستخدم غير موجود.');
    }
  }

  // Future<void> getDetails() async {
  //   // var usId = FirebaseAuth.instance.currentUser;
  //   try {
  //     await db.collection("frinds").doc("message").get().then((
  //       dataFromFirestore,
  //     ) {
  //       print(dataFromFirestore.data()?["frind"]["messages"] ?? "");
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> addmessage() async {
  //   // var usId = FirebaseAuth.instance.currentUser;
  //   try {
  //     await db.collection("frinds").doc("message").update({
  //       'frind.messages': FieldValue.arrayUnion(["Welcome"]),
  //     });
  //   } catch (e) {
  //     print("error");
  //   }
  // }

  // Future<void> checkemail() async {
  //   var usId = FirebaseAuth.instance.currentUser;
  //   try {
  //     await db.collection("users").doc(usId!.uid).get().then((
  //       dataFromFirestore,
  //     ) {
  //       if (dataFromFirestore["Email"] == Email.text) {
  //         print("is found");
  //       } else {
  //         print("not found");
  //         print(Email.text);
  //         print(usId.uid);
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> filed() async {
  //   var usId = FirebaseAuth.instance.currentUser;
  //   try {
  //     db
  //         .collection("frinds")
  //         .where("frind", isEqualTo: "abc@gmail.com")
  //         .get()
  //         .then((dataFromFirestore) {
  //           print(dataFromFirestore);
  //         });
  //   } catch (e) {
  //     print("eROOR");
  //   }
  // }
  Future<void> deletuser(String id) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(title: Text("Login ")),
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("assets/images/logo.png"),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: Name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                },
                decoration: InputDecoration(label: Text("Name")),
              ),
              TextFormField(
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: Email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                },
                decoration: InputDecoration(label: Text("Email")),
              ),

              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (userForm.currentState!.validate()) {
                          // setState(() {});
                          // await LoginControler.login(
                          //   context: context,
                          //   Email: Email.text,
                          //   Name: Name.text,
                          // );
                          // sendmessage();
                          //addmessage();
                          //getDetails();
                          //checkemail();
                          //filed();
                          addFrind();
                        }
                      },
                      child:
                          isLoading ? CircularProgressIndicator() : Text("Add"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
