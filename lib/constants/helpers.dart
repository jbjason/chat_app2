import 'dart:math';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';

abstract class Helpers {
  static final random = Random();

  static String randomPictureUrl() {
    final randomInt = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomInt/300/300';
  }

  // static DateTime randomDate() {
  //   final random = Random();
  //   final currentDate = DateTime.now();
  //   return currentDate.subtract(Duration(seconds: random.nextInt(200000)));
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String uid) =>
      FirebaseFirestore.instance
          .collection('chats/$uid/message')
          .orderBy('messageDate', descending: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() =>
      FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastMsgTime', descending: true)
          .snapshots();
}

class DataStore extends ChangeNotifier {
  List<UserData> _usersList = [];

  void setUsers(List<QueryDocumentSnapshot<Object?>> userObjectList) {
    final List<UserData> f = [];
    userObjectList.forEach((element) {
      f.add(
        UserData(
          userId: element['userId'],
          imageUrl: element['imageUrl'],
          userName: element['userName'],
          email: element['email'],
          lastMsgTime: DateTime.parse(element['lastMsgTime']),
          lastMsg: element['lastMsg'],
        ),
      );
    });
    _usersList = f;
    //notifyListeners();
  }

  List<UserData> get usersList {
    return [..._usersList];
  }

  UserData findUserById(String id) {
    return _usersList.firstWhere((element) => element.userId == id);
  }
}
