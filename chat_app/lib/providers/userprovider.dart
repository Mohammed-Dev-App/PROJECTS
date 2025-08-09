import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier {
  String userName = " ";
  String userEmail = "";
  String userId = "";
  bool isDarkMode = false;
  bool isFound = true;

  var db = FirebaseFirestore.instance;
  Future<void> getDetails() async {
    var usId = FirebaseAuth.instance.currentUser;
    // FutureBuilder(
    //   future: db.collection("users").doc(usId!.uid).get(),
    //   builder: (context, snapshot) {
    //     try {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if ((!snapshot.hasData || !snapshot.data!.exists)) {
    //         return Center(child: Text('No Data check your connectin'));
    //       } else if (snapshot.hasData &&
    //           snapshot.data!.exists &&
    //           snapshot.data!.data() != null) {
    //         userName = snapshot.data!?["Name"] ?? "";
    //         userEmail = snapshot.data!?["Email"] ?? "";
    //         userId = snapshot.data!?["id"] ?? "";
    //         notifyListeners();
    //       }
    //     } catch (e) {
    //        return  Center(child: CircularProgressIndicator());;
    //     }

    //   },
    // );
    try {
      await db.collection("users").doc(usId!.uid).get().then((
        dataFromFirestore,
      ) {
        userName = dataFromFirestore.data()!["Name"] ?? "";
        userEmail = dataFromFirestore.data()!["Email"] ?? "";
        userId = dataFromFirestore.data()!["id"] ?? "";

        notifyListeners();
      });
    } catch (e) {
      print("The error found in $e");
      print(e);
    }
  }

  void screenMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
