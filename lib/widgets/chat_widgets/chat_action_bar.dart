import 'package:chat_app2/constants/api_call.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/common_widgets/glowing_action_button.dart';
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
          // camera icon
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
          // textfield
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: textController,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14,
                    ),
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
                  // sending msg to cloud database
                  ApiCall().sendMessage(currentUser, messageData, text);
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
