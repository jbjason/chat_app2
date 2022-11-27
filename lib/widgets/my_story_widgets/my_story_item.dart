import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/my_story_screen/add_story_screen.dart';
import 'package:flutter/material.dart';

class MyStoryItem extends StatelessWidget {
  const MyStoryItem({Key? key, required this.index, required this.currentUser})
      : super(key: key);
  final int index;
  final UserData currentUser;

  @override
  Widget build(BuildContext context) {
    return index == 0 ? _currentUserInfo(context) : _friendUserInfo();
  }

  Widget _friendUserInfo() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.teal[100 * ((index + 1) % 9)],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(currentUser.imageUrl),
            ),
            const Text(
              'Jb Jason',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _currentUserInfo(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddStoryScreen(currentUser: currentUser)));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: NetworkImage(currentUser.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CircleAvatar(
                radius: 18,
                child: Icon(Icons.add),
              ),
              Text(
                'Add to Story',
                style: TextStyle(
                  // color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
}
