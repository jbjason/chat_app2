import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/common_widgets/glowing_action_button.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              child: _MessageList(
            messageData: messageData,
            currentUser: currentUser,
          )),
          _ActionBar(
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
      title: _AppBarTitle(
        messageData: messageData,
      ),
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

class _MessageList extends StatelessWidget {
  const _MessageList(
      {Key? key, required this.currentUser, required this.messageData})
      : super(key: key);
  final UserData currentUser;
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StreamBuilder(
        stream: Helpers.getMessages(currentUser.userId, messageData.userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.hasError) {
              return const Center(child: Text('Error Occured!'));
            } else {
              final userDocs = snapShot.data!.docs;
              if (userDocs.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(messageData.img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      messageData.userName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 7),
                    const Text('Private Message'),
                    const Text('You are now Friends on Messenger'),
                  ],
                );
              } else {
                return ListView.builder(
                  reverse: true,
                  itemCount: userDocs.length,
                  itemBuilder: (context, index) {
                    if (userDocs[index]['userId'] == currentUser.userId) {
                      return _MessageOwnTile(
                        message: userDocs[index]['message'],
                        messageDate:
                            DateTime.parse(userDocs[index]['messageDate']),
                      );
                    } else {
                      return _MessageTile(
                        message: userDocs[index]['message'],
                        messageDate:
                            DateTime.parse(userDocs[index]['messageDate']),
                      );
                    }
                  },
                );
              }
            }
          }
        },
      ),
    );
  }

  // child: ListView(
  //   children: const [
  //     _DateLable(lable: 'Yesterday'),
  //     _MessageTile(
  //       message: 'Hi, Lucy! How\'s your day going?',
  //       messageDate: '12:01 PM',
  //     ),
  //     _MessageOwnTile(
  //       message: 'You know how it goes...',
  //       messageDate: '12:02 PM',
  //     ),
  //     _MessageTile(
  //       message: 'Do you want Starbucks?',
  //       messageDate: '12:02 PM',
  //     ),
  //     _MessageOwnTile(
  //       message: 'Would be awesome!',
  //       messageDate: '12:03 PM',
  //     ),
  //     _MessageTile(
  //       message: 'Coming up!',
  //       messageDate: '12:03 PM',
  //     ),
  //     _MessageOwnTile(
  //       message: 'YAY!!!',
  //       messageDate: '12:03 PM',
  //     ),
  //   ],
  // ),

}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
    required this.messageDate,
  }) : super(key: key);

  final String message;
  final DateTime messageDate;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                  topRight: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Text(message),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat('h:mm a').format(messageDate),
                style: const TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MessageOwnTile extends StatelessWidget {
  const _MessageOwnTile({
    Key? key,
    required this.message,
    required this.messageDate,
  }) : super(key: key);

  final String message;
  final DateTime messageDate;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                  bottomLeft: Radius.circular(_borderRadius),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Text(message,
                    style: const TextStyle(
                      color: AppColors.textLigth,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat('h:mm a').format(messageDate),
                style: const TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DateLable extends StatelessWidget {
  const _DateLable({
    Key? key,
    required this.lable,
  }) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
            child: Text(
              lable,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textFaded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
            radius: 16, backgroundImage: NetworkImage(messageData.img)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageData.userName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 2),
              const Text(
                'Online now',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  _ActionBar({
    Key? key,
    required this.messageData,
    required this.currentUser,
  }) : super(key: key);
  final MessageData messageData;
  final UserData currentUser;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                CupertinoIcons.camera_fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: textController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // add Button
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 24.0,
            ),
            child: GlowingActionButton(
              color: AppColors.accent,
              icon: Icons.send_rounded,
              onPressed: () {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  // saving msg to sender msg collection
                  FirebaseFirestore.instance
                      .collection(
                          'chats/${currentUser.userId}/chat/${messageData.userId}/message')
                      .add({
                    'userId': currentUser.userId,
                    'userName': currentUser.userName,
                    'img': currentUser.imageUrl,
                    'messageDate': DateTime.now().toIso8601String(),
                    'message': text,
                  });
                  // saving msg to receriver msg collection
                  FirebaseFirestore.instance
                      .collection(
                          'chats/${messageData.userId}/chat/${currentUser.userId}/message')
                      .add({
                    'userId': currentUser.userId,
                    'userName': currentUser.userName,
                    'img': currentUser.imageUrl,
                    'messageDate': DateTime.now().toIso8601String(),
                    'message': text,
                  });
                  // changin currentUsers lastMsg & lastMsgTime
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.userId)
                      .update({
                    'lastMsg': text,
                    'lastMsgTime': DateTime.now().toIso8601String(),
                  });
                  // changin currentUsers lastMsg & lastMsgTime
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(messageData.userId)
                      .update({
                    'lastMsg': text,
                    'lastMsgTime': DateTime.now().toIso8601String(),
                  });
                  textController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
