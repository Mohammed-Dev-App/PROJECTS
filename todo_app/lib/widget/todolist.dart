// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todolist extends StatefulWidget {
  List<String> todoList;
  void Function() UpdateLocalData;
  Todolist({super.key, required this.todoList, required this.UpdateLocalData});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  // this function when list item click
  void OnItemClick({required int index}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.todoList.removeAt(index);
              });
              Navigator.pop(context);
              widget.UpdateLocalData();
            },
            child: Text("Mark is Done"),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: UniqueKey(),
          // secondaryBackground: Container(
          //   color: Colors.red,
          //   child: Row(
          //     //crossAxisAlignment: CrossAxisAlignment.end,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [Icon(Icons.delete_forever)],
          //   ),
          // ),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.green,
            child: Row(children: [Icon(Icons.check)]),
          ),
          onDismissed: (direction) {
            //direction detected the item drag to right or left
            //  if (direction == DismissDirection.startToEnd) {
            setState(() {
              widget.todoList.removeAt(index);
            });
            //Navigator.pop(context);
            widget.UpdateLocalData();
            // } //  direction:
            //   Colors.green;
          },
          child: ListTile(
            onTap: () {
              OnItemClick(index: index);
            },
            title:
                widget.todoList.isEmpty
                    ? Text("There is no found item in todo list")
                    : Text(widget.todoList[index]),
            // trailing: Icon(Icons.arrow_back_ios_new_rounded),
            // leading: Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }
}
