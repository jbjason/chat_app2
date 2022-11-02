import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/widgets/chat_widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  const MessageList(
      {Key? key, required this.currentUser, required this.messageData})
      : super(key: key);
  final UserData currentUser;
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StreamBuilder(
        stream: Helpers.getChats(currentUser.userId, messageData.userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.hasError) {
              return const Center(child: Text('Error Occured!'));
            } else {
              final userDocs = snapShot.data!.docs;
              if (userDocs.isNotEmpty) {
                return ListView.builder(
                  reverse: true,
                  itemCount: userDocs.length,
                  itemBuilder: (context, index) {
                    if (userDocs[index]['userId'] == currentUser.userId) {
                      return MessageOwnTile(
                        message: userDocs[index]['message'],
                        messageDate:
                            DateTime.parse(userDocs[index]['messageDate']),
                      );
                    } else {
                      return MessageTile(
                        message: userDocs[index]['message'],
                        messageDate:
                            DateTime.parse(userDocs[index]['messageDate']),
                      );
                    }
                  },
                );
              } else {
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
              }
            }
          }
        },
      ),
    );
  }
}
