import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app2/models/user_data.dart';

class DataStore with ChangeNotifier {
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
  }

  List<UserData> get usersList {
    return [..._usersList];
  }

  UserData findUserById(String id) {
    return _usersList.firstWhere((element) => element.userId == id);
  }
}
