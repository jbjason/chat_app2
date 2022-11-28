import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:flutter/material.dart';

class MysItemFriend extends StatelessWidget {
  const MysItemFriend(
      {Key? key,
      required this.index,
      required this.storyItem,
      required this.currentUser})
      : super(key: key);
  final int index;
  final UserData currentUser;
  final MyStory storyItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(storyItem.stroyImg)),
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
              backgroundImage: NetworkImage(storyItem.userImg),
            ),
          ),
          Text(
            storyItem.userName,
            style: const TextStyle(
              color: AppColors.textLigth,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
