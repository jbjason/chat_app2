import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app2/models/user_data.dart';

class DataStore with ChangeNotifier {
  List<UserData> _usersList = [];

  Future setUsersWithDate(List<QueryDocumentSnapshot<Object?>> userObjectList,
      String currentUserId) async {
    final List<UserData> data = [];
    for (int i = 0; i < userObjectList.length; i++) {
      // adding to _usersList if not current user
      if (userObjectList[i]['userId'] != currentUserId) {
        final userId = userObjectList[i]['userId'];
        final f = await FirebaseFirestore.instance
            .collection('msgHistory/$currentUserId/user/$userId/msg')
            .get();
        data.add(UserData(
          userId: userObjectList[i]['userId'],
          imageUrl: userObjectList[i]['imageUrl'],
          userName: userObjectList[i]['userName'],
          email: userObjectList[i]['email'],
          lastMsgTime: f.docs.isEmpty
              ? DateTime.parse(userObjectList[i]['lastMsgTime'])
              : DateTime.parse(f.docs[0]['lastMsgTime']),
          lastMsg: f.docs.isEmpty
              ? 'You are now Friends with ${userObjectList[i]['userName']}. Say Hiii to!'
              : f.docs[0]['lastMsg'],
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
}
