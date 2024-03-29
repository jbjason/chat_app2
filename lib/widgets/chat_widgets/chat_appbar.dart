import 'package:chat_app2/models/message_data.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
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
              // userName
              Text(
                messageData.userName,
                overflow: TextOverflow.ellipsis,
                // header2
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 2),
              // Online now status text
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
