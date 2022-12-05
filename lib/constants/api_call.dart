import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiCall {
  void sendMessage(UserData currentUser, MessageData messageData, String text) {
    final date = DateTime.now().toIso8601String();
    try {
      // saving msg to sender msg collection
      FirebaseFirestore.instance
          .collection(
              'chats/${currentUser.userId}/chat/${messageData.userId}/message')
          .add({
        'userId': currentUser.userId,
        'userName': currentUser.userName,
        'img': currentUser.imageUrl,
        'messageDate': date,
        'message': text,
      });
      // saving msg to receriver msg collection
      FirebaseFirestore.instance
          .collection(
              'chats/${messageData.userId}/chat/${currentUser.userId}/message')
          .add({
        'userId': currentUser.userId,
        'userName': currentUser.userName,
        'img': currentUser.imageUrl,
        'messageDate': date,
        'message': text,
      });
      // changin currentUsers lastMsg & lastMsgTime
      FirebaseFirestore.instance
          .collection('msgHistory')
          .doc(messageData.userId)
          .collection('user')
          .doc(currentUser.userId)
          .set({
        'lastMsg': text,
        'lastMsgTime': date,
        'userId': messageData.userId,
      });
      // changin RECEIVER lastMsg & lastMsgTime
      FirebaseFirestore.instance
          .collection('msgHistory')
          .doc(currentUser.userId)
          .collection('user')
          .doc(messageData.userId)
          .set({
        'lastMsg': text,
        'lastMsgTime': date,
        'userId': messageData.userId,
      });
    } catch (error) {
      rethrow;
    }
  }
}
