import 'package:chat_app2/models/my_story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyStoryStore with ChangeNotifier {
  List<MyStory> _myStories = [];

  List<MyStory> get myStories => [..._myStories];

  void setMyStories(List<QueryDocumentSnapshot<Object?>> data) {
    final List<MyStory> _stories = [];
    try {
      for (int i = 0; i < data.length; i++) {
        _stories.add(
          MyStory(
            id: data[i].id,
            userId: data[i]['userId'],
            userName: data[i]['userName'],
            userImg: data[i]['userImg'],
            stroyImg: data[i]['storyImg'],
          ),
        );
      }
      _myStories = _stories;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
