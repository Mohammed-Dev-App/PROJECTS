import 'package:chat_master/models/chat_masseges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CAHT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseService() {}
  Future<void> createUser(
    String _name,
    String _uid,
    String _email,
    String _imageURL,
  ) async {
    try {
      await db.collection(USER_COLLECTION).doc(_uid).set({
        'email;': _email,
        'image': _imageURL,
        'name': _name,
        'lastActive': DateTime.now().toUtc(),
      });
    } catch (e) {}
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = db.collection(USER_COLLECTION);

    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + 'z');
    }
    return _query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return db
        .collection(CAHT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chat_id) {
    return db
        .collection(CAHT_COLLECTION)
        .doc(_chat_id)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatId) {
    return db
        .collection(CAHT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatId, ChatMessages message) async {
    try {
      await db
          .collection(CAHT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGES_COLLECTION)
          .add(message.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
    String _chatId,
    Map<String, dynamic> _data,
  ) async {
    try {
      await db.collection(CAHT_COLLECTION).doc(_chatId).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserSeenTime(String _uid) async {
    try {
      await db.collection(USER_COLLECTION).doc(_uid).update({
        'lastActive': DateTime.now().toUtc(),
      });
    } catch (e) {
      print("The user Not Changed");
    }
  }

  Future<void> deleteChat(String _chatId) async {
    try {
      await db.collection(CAHT_COLLECTION).doc(_chatId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat = await db.collection(CAHT_COLLECTION).add(_data);
      return _chat;
    } catch (e) {
      print(e);
    }
  }
}
