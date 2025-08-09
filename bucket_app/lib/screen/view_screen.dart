import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItemScreen extends StatefulWidget {
  String title;
  String image;

  int index;
  ViewItemScreen({
    super.key,
    required this.title,
    required this.image,

    required this.index,
  });

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
        "https://flutter-test-api-8abc0-default-rtdb.firebaseio.com/bucketList/${widget.index}.json",
      );
      Navigator.pop(context, "refresh");
    } catch (e) {}
  }

  Future<void> markAscomplete() async {
    Map<String, dynamic> data = {"completed": true};
    try {
      Response response = await Dio().patch(
        "https://flutter-test-api-8abc0-default-rtdb.firebaseio.com/bucketList/${widget.index}.json",
        data: data,
      );
      Navigator.pop(context, "refresh");
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are sure to delete"),
                      actions: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        InkWell(onTap: deleteData, child: Text("Confirm")),
                      ],
                    );
                  },
                );
              }
              if (value == 2) {
                markAscomplete();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text("Delete"), value: 1),
                PopupMenuItem(child: Text("Mark is complete"), value: 2),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            //height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.image),
              ),
              // borderRadius: BorderRadius.circular(400),
            ),

            child: Image.network(widget.image),
          ),
        ],
      ),
    );
  }
}
