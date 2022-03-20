import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/chat_widgets/action_bar.dart';
import 'package:chat_app2/widgets/chat_widgets/appbar_title.dart';
import 'package:chat_app2/widgets/chat_widgets/message_list.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {Key? key, required this.currentUser, required this.messageData})
      : super(key: key);
  final MessageData messageData;
  final UserData currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _appBar(context),
      ),
      body: Column(
        children: [
          Expanded(
              child: MessageList(
            messageData: messageData,
            currentUser: currentUser,
          )),
          ActionBar(
            messageData: messageData,
            currentUser: currentUser,
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 54,
      leading: Align(
        alignment: Alignment.centerRight,
        child: IconBackground(
          icon: CupertinoIcons.back,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      title: AppBarTitle(messageData: messageData),
      // camera & video_call icon
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: IconBorder(
              icon: CupertinoIcons.video_camera_solid,
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Center(
            child: IconBorder(
              icon: CupertinoIcons.phone_solid,
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
