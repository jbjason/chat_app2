import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/my_story_widgets/mys_item_friend.dart';
import 'package:chat_app2/widgets/my_story_widgets/mys_item_user.dart';
import 'package:flutter/material.dart';

class MysBody extends StatelessWidget {
  const MysBody({Key? key, required this.myStories, required this.currentUser})
      : super(key: key);
  final UserData currentUser;
  final List<MyStory> myStories;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => index == 0
            ? MysItemUser(currentUser: currentUser)
            : MysItemFriend(
                index: index,
                currentUser: currentUser,
                storyItem: myStories[index - 1],
              ),
        childCount: myStories.length + 1, // +1 cz 1-addStory Item
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .79,
      ),
    );
  }
}
