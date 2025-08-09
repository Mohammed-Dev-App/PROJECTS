import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeName extends StatefulWidget {
  String sender_id;
  String receivied_id;
  ChangeName({super.key, required this.sender_id, required this.receivied_id});

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  var userForm = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  var db = FirebaseFirestore.instance;
  Future<void> changeName() async {
    String recived = widget.receivied_id;
    await db.collection("frinds").doc(widget.sender_id).update({
      '$recived.name': name.text,
    });

    Navigator.pop(context);
  }

  Future<void> remove() async {
    await db.collection("frindslist").doc(widget.sender_id).update({
      'frindlist': FieldValue.arrayRemove([widget.receivied_id]),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change name"),
        actions: [
          InkWell(
            onTap: remove,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete),
            ),
          ),
        ],
      ),
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
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Where is your new name";
                  }
                },
                decoration: InputDecoration(label: Text("Name")),
              ),
              SizedBox(height: 15),
              ElevatedButton(onPressed: changeName, child: Text("Change")),
            ],
          ),
        ),
      ),
    );
  }
}
