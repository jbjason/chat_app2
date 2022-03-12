import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Helpers {
  static final random = Random();

  static String randomPictureUrl() {
    final randomInt = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomInt/300/300';
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() =>
      FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastMsgTime', descending: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
          String currentUserId, String userId) =>
      FirebaseFirestore.instance
          .collection('chats/$currentUserId/chat/$userId/message')
          .orderBy('messageDate', descending: true)
          .snapshots();
}

