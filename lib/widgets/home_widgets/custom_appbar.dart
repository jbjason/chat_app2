import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.currentUserIndex,
    required this.users,
  }) : super(key: key);
  final List<UserData> users;
  final int currentUserIndex;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: kToolbarHeight + 5,
      pinned: true,
      centerTitle: true,
      leadingWidth: 54,
      leading: Align(
        alignment: Alignment.centerRight,
        child: IconBackground(
          icon: Icons.search,
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
      title: const Text(
        'Messages',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0, top: 3),
          child: currentUserIndex != -1
              ? CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage(users[currentUserIndex].imageUrl),
                )
              : const CircleAvatar(radius: 18),
        ),
      ],
    );
  }
}
