import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/my_story_screen/add_story_screen.dart';
import 'package:flutter/material.dart';

class MysItemUser extends StatelessWidget {
  const MysItemUser({Key? key, required this.currentUser}) : super(key: key);
  final UserData currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AddStoryScreen(currentUser: currentUser)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(40),
          image: DecorationImage(
            image: NetworkImage(currentUser.imageUrl),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CircleAvatar(
              radius: 21,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 19.5,
                child: Icon(Icons.add, color: AppColors.secondary),
              ),
            ),
            Text(
              'Add to Story',
              style: TextStyle(
                  color: AppColors.textLigth, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
