import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app2/models/user_data.dart';

class DataStore with ChangeNotifier {
  List<UserData> _usersList = [];

  void setUsersWithDate(
    List<QueryDocumentSnapshot<Object?>> userObjectList,
    List<QueryDocumentSnapshot<Object?>> msgHistoryList,
    String currentUserId,
  ) {
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

  List<UserData> get usersList => [..._usersList];

  int findCurrentUserIndex(String currentUserId) =>
      _usersList.indexWhere((element) => element.userId == currentUserId);

  UserData findUserByIndex(int index) => _usersList[index];

  List<UserData> get sortedUsersList {
    final _sortedList = [..._usersList];
    _sortedList.sort(((a, b) => -(a.lastMsgTime).compareTo(b.lastMsgTime)));
    return [..._sortedList];
  }

  //newly added
  String status = '';
  String get getLoginStatus => status;

  void setLoginStatus(String s) {
    status = s;
    notifyListeners();
  }

  // this is for Showing Welcome to Chat app purpose
  String idUser = '', nameUser = '', urlUser = '', emailUser = '';
  DateTime _date = DateTime.now();
  void setSignUpUserInfo(
      String id, String name, String email, String url, DateTime date) {
    idUser = id;
    nameUser = name;
    emailUser = email;
    urlUser = url.replaceAll('///', '//');
    _date = date;
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
