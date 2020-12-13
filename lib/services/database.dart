import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future getUserbyUsername(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: userName)
        .get();
  }

  Future getUserbyEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError(
          (error) => print(
            error.toString(),
          ),
        );
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((onError) => {
              print(
                onError.toString(),
              ),
            });
  }

  addConversationMessages(String chatRoomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError(
          (onError) => print(
            onError.toString(),
          ),
        );
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChats(String userName) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
