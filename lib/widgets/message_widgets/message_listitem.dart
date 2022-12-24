import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageListItem extends StatelessWidget {
  const MessageListItem({
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
              // user name & last_msg
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
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    // Message
                    SizedBox(
                      height: 20,
                      child: Text(
                        messageData.message, // lastMsg
                        overflow: TextOverflow.ellipsis,
                        // bodyText2
                        style: Theme.of(context).textTheme.bodyText2,
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
                      style: Theme.of(context).textTheme.bodyText2,
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
