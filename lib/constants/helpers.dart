import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Helpers {
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() =>
      FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastMsgTime', descending: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
          String currentUserId, String userId) =>
      FirebaseFirestore.instance
          .collection('chats/$currentUserId/chat/$userId/message')
          .orderBy('messageDate', descending: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMsgHistory(
          String currentUserId) =>
      FirebaseFirestore.instance
          .collection('msgHistory/$currentUserId/user')
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyStories() =>
      FirebaseFirestore.instance.collection('mystory').snapshots();
}
