import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app2/models/user_data.dart';

class DataStore with ChangeNotifier {
  List<UserData> _usersList = [];

  int setUsersAndGetCurrentIndex(
      List<QueryDocumentSnapshot<Object?>> userObjectList, String id) {
    final List<UserData> f = [];
    userObjectList.forEach((element) {
      f.add(UserData(
        userId: element['userId'],
        imageUrl: element['imageUrl'],
        userName: element['userName'],
        email: element['email'],
        lastMsgTime: DateTime.parse(element['lastMsgTime']),
        lastMsg: element['lastMsg'],
      ));
    });
    _usersList = f;
    //Returns the first index in the list that satisfies the given conditions.
    //If nothing found, returns -1.
    return _usersList.indexWhere((element) => element.userId == id);
  }

  List<UserData> get usersList {
    return [..._usersList];
  }

  UserData findUserByIndex(int index) {
    return _usersList[index];
  }
}
