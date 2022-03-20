import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/widgets/home_widgets/message_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: Helpers.getUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapShot.hasError) {
            return const Center(child: Text('Error Occured!'));
          } else {
            final _userDocs = snapShot.data!.docs;
            return MessageBody(
              currentUserId: _currentUserId,
              userDocs: _userDocs,
              size: size,
            );
          }
        }
      },
    );
  }
}
