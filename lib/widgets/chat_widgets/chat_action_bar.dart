import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/common_widgets/glowing_action_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatActionBar extends StatelessWidget {
  ChatActionBar(
      {Key? key, required this.messageData, required this.currentUser})
      : super(key: key);
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
                      .collection('msgHistory')
                      .doc(messageData.userId)
                      .collection('user')
                      .doc(currentUser.userId)
                      .set({
                    'lastMsg': text,
                    'lastMsgTime': DateTime.now().toIso8601String(),
                    'userId': messageData.userId,
                  });
                  // changin RECEIVER lastMsg & lastMsgTime
                  FirebaseFirestore.instance
                      .collection('msgHistory')
                      .doc(currentUser.userId)
                      .collection('user')
                      .doc(messageData.userId)
                      .set({
                    'lastMsg': text,
                    'lastMsgTime': DateTime.now().toIso8601String(),
                    'userId': messageData.userId,
                  });
                  FocusScope.of(context).unfocus();
                  textController.text = '';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
