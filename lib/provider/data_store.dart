import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app2/models/user_data.dart';

class DataStore with ChangeNotifier {
  List<UserData> _usersList = [];

  Future<void> setUsersWithDate(
    List<QueryDocumentSnapshot<Object?>> userObjectList,
    List<QueryDocumentSnapshot<Object?>> msgHistoryList,
    String currentUserId,
  ) async {
    final List<UserData> data = [];
    for (int i = 0; i < userObjectList.length; i++) {
      if (userObjectList[i]['userId'] != currentUserId) {
        final userId = userObjectList[i]['userId'];
        final int indexOfLastMsg =
            msgHistoryList.indexWhere((element) => element['userId'] == userId);
        final lastMsgTime = msgHistoryList.isEmpty || indexOfLastMsg == -1
            ? userObjectList[i]['lastMsgTime']
            : msgHistoryList[indexOfLastMsg]['lastMsgTime'];
        final String lastMsg = msgHistoryList.isEmpty || indexOfLastMsg == -1
            ? 'You are now Friends with ${userObjectList[i]['userName']}. Say Hiii to!'
            : msgHistoryList[indexOfLastMsg]['lastMsg'];
        data.add(UserData(
          userId: userId,
          imageUrl: userObjectList[i]['imageUrl'],
          userName: userObjectList[i]['userName'],
          email: userObjectList[i]['email'],
          lastMsgTime: DateTime.parse(lastMsgTime),
          lastMsg: lastMsg,
        ));
      } else {
        // adding currentUser to _usersList
        data.add(UserData(
          userId: userObjectList[i]['userId'],
          imageUrl: userObjectList[i]['imageUrl'],
          userName: userObjectList[i]['userName'],
          email: userObjectList[i]['email'],
          lastMsgTime: DateTime.parse(userObjectList[i]['lastMsgTime']),
          lastMsg: '',
        ));
      }
    }
    _usersList = data;
  }

  List<UserData> get usersList {
    return [..._usersList];
  }

  List<UserData> get sortedUsersList {
    final _sortedList = [..._usersList];
    _sortedList.sort(((a, b) => -(a.lastMsgTime).compareTo(b.lastMsgTime)));
    return [..._sortedList];
  }

  int findCurrentUserIndex(String currentUserId) {
    return _usersList.indexWhere((element) => element.userId == currentUserId);
  }

  UserData findUserByIndex(int index) {
    return _usersList[index];
  }

  //newly added
  String status = '';
  void setLoginStatus(String s) {
    status = s;
    notifyListeners();
  }

  String get getLoginStatus {
    return status;
  }

  String idUser = '', nameUser = '', urlUser = '', emailUser = '';
  DateTime _date = DateTime.now();
  void setSignUpUserInfo(
      String i, String na, String em, String ur, DateTime da) {
    idUser = i;
    nameUser = na;
    emailUser = em;
    urlUser = ur.replaceAll('///', '//');
    _date = da;
    notifyListeners();
  }

  UserData get getUserInfo {
    return UserData(
      userId: idUser,
      imageUrl: urlUser,
      userName: nameUser,
      email: emailUser,
      lastMsgTime: _date,
      lastMsg: '',
    );
  }
}