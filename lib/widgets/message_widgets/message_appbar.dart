import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:chat_app2/widgets/message_widgets/message_search.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class MessageAppBar extends StatelessWidget {
  const MessageAppBar({
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
      // search Icon
      leading: _searchIcon(context),
      title: const Text(
        'Messages',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget _searchIcon(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: IconBackground(
          icon: Icons.search,
          onTap: () async {
            final f = await showSearch(
                context: context, delegate: MessageSearch(users: users));
            if (f != null) {
              final String difference =
                  Jiffy(DateTime.parse(f.lastMsgTime.toString().toString()))
                      .fromNow();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                      currentUser: users[currentUserIndex],
                      messageData: MessageData(
                          userId: f.userId,
                          userName: f.userName,
                          message: f.lastMsg,
                          dateDifference: difference,
                          img: f.imageUrl)),
                ),
              );
            }
          },
        ),
      );
}
