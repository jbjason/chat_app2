import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/message_widgets/message_listitem.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    Key? key,
    required this.usersList,
    required this.currentUserIndex,
    required this.currentUserId,
  }) : super(key: key);

  final List<UserData> usersList;
  final int currentUserIndex;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (currentUserId != usersList[index].userId) {
            final String difference = Jiffy(DateTime.parse(
                    usersList[index].lastMsgTime.toString().toString()))
                .fromNow();
            return MessageListItem(
              currentUserIndex: currentUserIndex,
              currentUserId: currentUserId,
              messageData: MessageData(
                userId: usersList[index].userId,
                userName: usersList[index].userName,
                message: usersList[index].lastMsg,
                dateDifference: difference,
                img: usersList[index].imageUrl,
              ),
            );
          } else {
            return Container();
          }
        },
        childCount: usersList.length,
      ),
    );
  }
}
