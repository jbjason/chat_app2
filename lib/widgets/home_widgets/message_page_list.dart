import 'package:chat_app2/constants/data_store.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

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
            return _MessageTitle(
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

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({
    Key? key,
    required this.currentUserIndex,
    required this.messageData,
    required this.currentUserId,
  }) : super(key: key);
  final int currentUserIndex;
  final String currentUserId;
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final user = Provider.of<DataStore>(context, listen: false)
            .findUserByIndex(currentUserIndex);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                ChatScreen(messageData: messageData, currentUser: user)));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              // profile pic
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(messageData.img),
                ),
              ),
              // profile_name & last_msg
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // userName
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        messageData.userName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    // Message
                    SizedBox(
                      height: 20,
                      child: Text(
                        messageData.message, // lastMsg
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Message & date details
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    // duration of msg
                    Text(
                      messageData.dateDifference,
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaded,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 1 new msg notification_icon
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                          color: AppColors.secondary, shape: BoxShape.circle),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLigth,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
