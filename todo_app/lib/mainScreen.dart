import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/addTodo.dart';
import 'package:todo_app/widget/todolist.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainScreen();
}

class _MainScreen extends State<Mainscreen> {
  //String text = "Simpl text";
  List<String> todoList = [];
  void ShowAddToBottom() {
    showModalBottomSheet(
      //backgroundColor: Colors.blueGrey,
      context: context,
      builder: (context) {
        return Padding(
          padding: (MediaQuery.of(context).viewInsets),
          child: Container(
            height: 200,

            //  padding: EdgeInsets.all(20),
            //padding: EdgeInsets.only(bottom: 97, top: 20, right: 20, left: 20),
            //padding: MediaQuery.of(context).viewInsets,
            child: AddtoState(AddTodo: AddTodo),
          ),
        );
      },
    );
  }

  void AddTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Already Exist"),
            content: Text("Todo text already Exist"),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      todoList.add(todoText);

      // text = "$todoText";
    });
    Navigator.pop(context); //do back button
    UpdateLocalData();
  }

  Future<void> UpdateLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save an list of strings to 'items' key.
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList = (prefs.getStringList('todoList') ?? []).toList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blueGrey[900],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: ShowAddToBottom,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey[900],
              height: 200,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Todo App",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www.blabla.com"));
              },
              leading: Icon(Icons.person),
              title: Text(
                "About Me",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("mailto:my@gmail.com"));
              },
              leading: Icon(Icons.person),
              title: Text(
                "Contact Me",
                // style:  TextStyle(fontWeight: "M"=="M"?FontWeight.bold:FontWeight.normal),
                style: TextStyle(
                  fontWeight: "M" == "M" ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        // child: ListView.builder(
        //   itemCount: todoList.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile(
        //       title: Text(todoList[index]),
        //       // trailing: Icon(Icons.arrow_back_ios_new_rounded),
        //       // leading: Icon(Icons.arrow_back),
        //     );
        //   },
        // ),
      ),
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
        // actions: [
        //   InkWell(
        //     // // splashColor: Colors.green,
        //     // enableFeedback: false, //disable the sound when you click
        //     // splashColor: Colors.transparent, //do the area of color just
        //     // highlightColor: Colors.transparent, //remove the area of color
        //     onTap: ShowAddToBottom,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       // child: GestureDetector(
        //       //   onTap: () {
        //       //     print("plus is click");
        //       //   },
        //       //   child: Icon(Icons.add),
        //       // ),
        //       // child: InkWell(
        //       //   onTap: () {
        //       //     print("plus is click");
        //       //   },
        //       //   child: Icon(Icons.add),
        //       // ),

        //     ),
        //   ),
        // ],
      ),
      body:
          todoList.isEmpty
              ? Center(child: Text("There is no found item in todo list"))
              : Todolist(todoList: todoList, UpdateLocalData: UpdateLocalData),
      // Container(
      //   child: Text('$text'),
      // ), // AddtoState(), // GestureDetector(onTap: () {}, child: Text("data")),
    );
  }
}
