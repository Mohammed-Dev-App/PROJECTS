import 'package:chat_app/providers/userprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameText = TextEditingController();
  var editprofForm = GlobalKey<FormState>();
  var userId = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  void updateData() {
    Map<String, dynamic> dataUpdate = {"Name": nameText.text};
    db
        .collection("users")
        .doc(Provider.of<Userprovider>(context, listen: false).userId)
        .update(dataUpdate);
    Provider.of<Userprovider>(context, listen: false).getDetails();
    Navigator.pop(context);
  }

  @override
  void initState() {
    nameText.text = Provider.of<Userprovider>(context, listen: false).userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (editprofForm.currentState!.validate()) {
                  updateData();
                }
              },
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editprofForm,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    }
                  },
                  decoration: InputDecoration(label: Text("Name")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
