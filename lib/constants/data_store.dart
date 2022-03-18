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
        final lastMsgTime =
            msgHistoryList.firstWhere((element) => element['userId'] == userId);
        final String lastMsg = lastMsgTime['lastMsg'];
        data.add(UserData(
          userId: userId,
          imageUrl: userObjectList[i]['imageUrl'],
          userName: userObjectList[i]['userName'],
          email: userObjectList[i]['email'],
          lastMsgTime: DateTime.parse(lastMsgTime['lastMsgTime']),
          lastMsg: lastMsg.isEmpty
              ? 'You are now Friends with ${userObjectList[i]['userName']}. Say Hiii to!'
              : lastMsgTime['lastMsg'],
        ));
      } else {
        // adding currentUser to _usersList
        data.add(UserData(
          userId: userObjectList[i]['userId'],
          imageUrl: userObjectList[i]['imageUrl'],
          userName: userObjectList[i]['userName'],
          email: userObjectList[i]['email'],
          lastMsgTime: userObjectList[i]['lastMsgTime'],
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
  void setLoginStatus(String s) => status = s;
  String get getLoginStatus {
    return status;
  }

  String _userId = '', _userName = '', _userUrl = '', _email = '';
  late DateTime _date;
  void setSignUpUserInfo(
      String id, String namee, String emaill, String url, DateTime datee) {
    _userId = id;
    _userName = namee;
    _email = emaill;
    _userUrl = url;
    _date = datee;
  }

  UserData get getUserInfo => UserData(
        userId: _userId,
        imageUrl: _userUrl,
        userName: _userName,
        email: _email,
        lastMsgTime: _date,
        lastMsg: '',
      );
}
