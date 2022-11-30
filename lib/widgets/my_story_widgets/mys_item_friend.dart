import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/my_story_screen/view_story_screen.dart';
import 'package:flutter/material.dart';

class MysItemFriend extends StatelessWidget {
  const MysItemFriend(
      {Key? key,
      required this.index,
      required this.myStory,
      required this.currentUser})
      : super(key: key);
  final int index;
  final UserData currentUser;
  final MyStory myStory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => ViewStoryScreen(story: myStory)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              image: NetworkImage(myStory.storyItem[0].img), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.iconLight,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(myStory.userImg),
              ),
            ),
            Text(
              myStory.userName,
              style: const TextStyle(
                color: AppColors.textLigth,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
