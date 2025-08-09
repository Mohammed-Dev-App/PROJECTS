import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddtoState extends StatefulWidget {
  void Function({required String todoText}) AddTodo;
  AddtoState({super.key, required this.AddTodo});

  @override
  State<AddtoState> createState() => _AddtoStateState();
}

class _AddtoStateState extends State<AddtoState> {
  TextEditingController todotext = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Text("Hello"),
        TextField(
          onSubmitted: (ValueKey) {
            if (todotext.text != "") {
              widget.AddTodo(todoText: todotext.text);
            }
          },
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Write your todo text",
            // labelText: "username",
            // icon: Icon(Icons.camera),
            contentPadding: EdgeInsets.all(8.0),
          ),
          //style: TextStyle(fontWeight: FontWeight.bold),
          controller: todotext,
        ),
        SingleChildScrollView(
          child: ElevatedButton(
            onPressed: () {
              if (todotext.text != "") {
                widget.AddTodo(todoText: todotext.text);
              }
              // print(todotext.text);
            },
            child: Text("ADD"),
          ),
        ),
      ],
    );
  }
}
