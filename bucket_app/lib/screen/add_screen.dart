import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  int newIndex;
  AddItem({super.key, required this.newIndex});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController textname = TextEditingController();
  TextEditingController texturi = TextEditingController();
  TextEditingController textcost = TextEditingController();
  Future<void> AddData() async {
    Map<String, dynamic> data = {
      "item": textname.text,
      "image": texturi.text,
      "cost": textcost.text,
      "completed": false,
    };
    try {
      Response response = await Dio().patch(
        "https://flutter-test-api-8abc0-default-rtdb.firebaseio.com/bucketList/${widget.newIndex}.json",
        data: data,
      );
      setState(() {});
      Navigator.pop(context, "refresh");
    } catch (e) {}
  }

  // @override
  // void initState() {
  //   AddData();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var addform = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Add Bucket List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: addform,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error Invalid Item";
                  }
                  if (value.toString().length < 3) {
                    return "This must be more than 3 charcter";
                  }
                },
                autofocus: true,
                decoration: InputDecoration(
                  label: Text("item"),
                  hintText: "The name of picture",
                  contentPadding: EdgeInsets.all(8.0),
                ),
                controller: textname,
              ),
              SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (!Uri.parse(value.toString()).isAbsolute) {
                    return "This Must be Valid URI";
                  }
                  if (value.toString().length < 10) {
                    return "This Must be More than 10";
                  }
                },
                autofocus: true,
                decoration: InputDecoration(
                  label: Text("image"),
                  hintText: "The URI of picture",
                  contentPadding: EdgeInsets.all(8.0),
                ),
                controller: texturi,
              ),
              SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error Invalid Item";
                  }
                  if (value.toString().length < 3) {
                    return "This must be more than 3 charcter";
                  }
                },
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "The Cost",
                  label: Text("Cost"),
                  contentPadding: EdgeInsets.all(8.0),
                ),
                controller: textcost,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (addform.currentState!.validate()) {
                          AddData();
                        }
                      },
                      child: Text("Add Bucket"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
