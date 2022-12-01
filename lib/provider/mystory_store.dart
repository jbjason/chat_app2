import 'package:chat_app2/constants/constants.dart';
import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class MyStoryStore with ChangeNotifier {
  List<MyStory> _myStories = [];
  List<MyStory> get myStories => [..._myStories];

  MyStoryId getStory(UserData user, MyStoryItem item) {
    final f = _myStories.indexWhere((element) => element.userId == user.userId);
    List<MyStoryItem> _storyItem = [];
    String _storyId = '';
    // if users story already not existed then setting
    if (f == -1) {
      _storyItem = [item];
    } else {
      // if users story already existed then adding the new
      (_myStories[f].storyItem).insert(0, item);
      _storyItem = (_myStories[f].storyItem);
      _storyId = _myStories[f].id;
    }
    // converting StoryItem
    return MyStoryId(
      storyId: _storyId,
      mapItem: {
        'userId': user.userId,
        'userName': user.userName,
        'userImg': user.imageUrl,
        'storyItem': _storyItem
            .map((e) => {
                  "img": e.img,
                  "dateTime": e.dateTime.toIso8601String(),
                  'urlPath': e.urlPath,
                })
            .toList(),
      },
    );
  }

  void setMyStories(List<QueryDocumentSnapshot<Object?>> data) async {
    final List<MyStory> _stories = [];
    try {
      for (int i = 0; i < data.length; i++) {
        _stories.add(
          MyStory(
            id: data[i].id,
            userId: data[i]['userId'],
            userName: data[i]['userName'],
            userImg: data[i]['userImg'],
            storyItem: (data[i]['storyItem'] as List<dynamic>)
                .map(
                  (item) => MyStoryItem(
                    img: item['img'],
                    dateTime: DateTime.parse(item['dateTime']),
                    urlPath: item['urlPath'],
                  ),
                )
                .toList(),
          ),
        );
      }
      _myStories = _stories;
      // cz sometime it causes error to fetch a long list to avoid dat this delay
      await Future.delayed(Duration.zero);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteStory(MyStory story, int selectedIndex) async {
    try {
      final _firebase = FirebaseFirestore.instance.collection('mystory');
      final _ref = FirebaseStorage.instance.ref();
      if (story.storyItem.length == 1) {
        await _firebase.doc(story.id).delete();
        await _ref.child(story.storyItem[0].urlPath).delete();
      } else {
        final _selectedItem = story.storyItem[selectedIndex];
        final _items = story.storyItem;
        _items.remove(_selectedItem);
        await _firebase.doc(story.id).update({
          "storyItem": _items
              .map((e) => {
                    "img": e.img,
                    "dateTime": e.dateTime.toIso8601String(),
                    "urlPath": e.urlPath,
                  })
              .toList(),
        });
        await _ref.child('my_story/${_selectedItem.urlPath}').delete();
      }
    } catch (e) {
      getSnackBar(e.toString(), const Color(0xFFFF5252));
    }
  }
}
