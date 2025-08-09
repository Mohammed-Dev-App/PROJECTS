import 'package:chat_app/providers/userprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  final String sender_id;
  final String received_id;
  final String chatroomName;
  final String senderName;

  ChatRoomScreen({
    super.key,
    required this.sender_id,
    required this.received_id,
    required this.chatroomName,
    required this.senderName,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var user = FirebaseAuth.instance.currentUser;
  TextEditingController messageText = TextEditingController();
  var db = FirebaseFirestore.instance;
  int i = 0;
  List<dynamic> senderMessage = [];
  List<dynamic> receivedMessage = [];
  List<dynamic> allmessages = [];
  String recevied_name = "";

  Future<void> sendmessage() async {
    String senderId = widget.received_id;
    if (messageText.text.isEmpty) {
      return;
    }
    print(widget.senderName);
    DateTime now = DateTime.now();
    Map<String, dynamic> messageToSend = {
      "sender_name": widget.senderName,
      "sender_id": widget.sender_id,
      "content": messageText.text,
      "timestamp": now.toString(),
    };
    try {
      await db.collection("frinds").doc(widget.sender_id).update({
        '$senderId.messages': FieldValue.arrayUnion([messageToSend]),
      });
      messageText.text = "";
    } catch (e) {
      print(senderId);
      print("Error  $e");
    }
  }

  Widget singalchat({
    required String sender,
    required var text,
    required String sender_id,
    required String time,
  }) {
    var id = Provider.of<Userprovider>(context).userId;

    DateTime dateTime = DateTime.parse(time);
    return Column(
      crossAxisAlignment:
          sender_id == user!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6.0),
          child: Text(
            sender_id == user!.uid
                ? Provider.of<Userprovider>(context, listen: false).userName
                : sender,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color:
                sender_id == user!.uid
                    ? Colors.grey[300]
                    : Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  text["content"].toString(),
                  style: TextStyle(
                    color:
                        sender_id ==
                                Provider.of<Userprovider>(
                                  context,
                                  listen: false,
                                ).userId
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          DateFormat('hh:mm a ').format(dateTime) as String,
          style: TextStyle(fontSize: 10),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatroomName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db.collection("frinds").doc(widget.sender_id).snapshots(),
              // db
              // .collection("frinds")
              // .where("chatroom_id", isEqualTo: widget.received_id)
              // .orderBy("time", descending: true)
              // .snapshots(),
              builder: (context, snapshot) {
                return StreamBuilder(
                  stream:
                      db
                          .collection("frinds")
                          .doc(widget.received_id)
                          .snapshots(),
                  builder: (context, snapshot2) {
                    try {
                      print(snapshot.data);
                    } catch (e) {
                      print("There found an error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot2.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || snapshot2.hasError) {
                      return Center(child: Text('Error '));
                    }

                    if ((!snapshot.hasData || !snapshot.data!.exists) &&
                        (!snapshot2.hasData || !snapshot2.data!.exists)) {
                      return Center(child: Text('No message'));
                    }
                    if (snapshot.hasData &&
                        snapshot.data!.exists &&
                        snapshot.data!.data() != null) {
                      print("there data found");
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final length = data.length;
                      print(length);
                      //   if (length > 2) {
                      receivedMessage =
                          snapshot2.data?[widget.sender_id]?["messages"] ?? [];
                      //    }
                    }
                    if (snapshot.data!.exists) {
                      senderMessage =
                          snapshot.data?[widget.received_id]["messages"] ?? [];
                    }
                    recevied_name = snapshot.data?[widget.received_id]['name'];
                    allmessages =
                        [
                          senderMessage,
                          receivedMessage,
                        ].expand((x) => x).toList();
                    allmessages.sort(
                      (a, b) => DateTime.parse(
                        b['timestamp'],
                      ).compareTo(DateTime.parse(a['timestamp'])),
                    );
                    print(allmessages);

                    print("The name for recived is $recevied_name");
                    if (allmessages.length < 1) {
                      return Text("No Message yet");
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: allmessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: singalchat(
                            sender: recevied_name,
                            text: allmessages[index],
                            sender_id: allmessages[index]["sender_id"],
                            time: allmessages[index]["timestamp"],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey[200],

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageText,
                      autofocus: true,
                      enabled: true,
                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        hintText: "Write your meassage here",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => sendmessage(),
                    child: Icon(Icons.send, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
