import 'package:bucket_app/screen/add_screen.dart';

import 'package:bucket_app/screen/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<dynamic> buckeListData = [];
  String url = "";
  bool isloading = false;
  bool isError = true;
  Future<void> getData() async {
    setState(() {
      isloading = true;
    });
    try {
      Response response = await Dio().get(
        "https://flutter-test-api-8abc0-default-rtdb.firebaseio.com/bucketList.json",
      );
      // Response response = await Dio().get(
      //   "https://lekmanga.net/manga/the-heroine-wants-me-as-her-sister-in-law/80/",
      // );
      isloading = false;
      isError = false;
      setState(() {});
      //print(response.data);

      /// print(response.statusCode);
      // url = response.data[0]['image'];
      if (response.data is List) {
        buckeListData = response.data;
      } else {
        buckeListData = [];
      }

      // showDialog(
      //   context: (context),

      //   builder: (builder) {
      //     CloseButton();
      //     //Image.network(url);
      //     return Image.network(url);
      //   },
      // );
    } catch (e) {
      isloading = false;
      isError = true;
      setState(() {});
      ;
    }
  }

  Widget errorwidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text("Error Getting Bucket List Data"),
          ElevatedButton(
            onPressed: () {
              getData();
            },
            child: Text("Try agine"),
          ),
        ],
      ),
    );
  }

  Widget ListDataWidget() {
    List<dynamic> filterList =
        buckeListData.where((element) {
          if (element == null) {
            return true;
          } else {
            return !element["completed"];
          }
        }).toList();
    return filterList.length < 1
        ? Center(child: Text("No data on bucket List"))
        : ListView.builder(
          itemCount: buckeListData.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  (buckeListData[index] is Map &&
                          !buckeListData[index]["completed"])
                      ? ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewItemScreen(
                                  index: index,
                                  title: buckeListData[index]['item'] ?? " ",
                                  image: buckeListData[index]['image'] ?? " ",
                                );
                              },
                            ),
                          ).then((value) {
                            //execute after return to main page
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        title: Text(buckeListData[index]?['item'] ?? " "),
                        //buckeListData[index]?['item'] ?? " " This maens if list is null then make list = " "
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            buckeListData[index]?['image'] ?? " ",
                          ),
                        ),
                        trailing: Text(
                          buckeListData[index]?['cost'].toString() ?? " ",
                        ),
                      )
                      : SizedBox(),
            );
          },
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket List"),
        actions: [
          InkWell(
            onTap: () {
              getData();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh, size: 30),
            ),
          ),
        ],
      ),
      // drawer: DrawerD(),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        child: Icon(Icons.add),
        // backgroundColor: Colors.blueGrey[200],
        onPressed: () {
          // Navigator.pushNamed(context, "add");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddItem(newIndex: buckeListData.length);
              },
            ),
          ).then((value) {
            if (value == "refresh") {
              getData();
            }
          });
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          CircularProgressIndicator();
          getData();
        },

        child:
            isloading
                ? Center(
                  child: CircularProgressIndicator(),
                ) //LinearProgressIndicator()
                : isError
                ? errorwidget()
                : buckeListData.length < 1
                ? Center(child: Text("There is no data in bucket list"))
                : ListDataWidget(),
      ),
    );
  }
}
