import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/provider/mystory_store.dart';
import 'package:chat_app2/widgets/my_story_widgets/mys_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyStoryScreen extends StatelessWidget {
  const MyStoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataStore>(context, listen: false);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final userId = data.findCurrentUserIndex(currentUserId);
    final currentUser = data.usersList[userId];
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Colors.transparent,
          expandedHeight: kToolbarHeight + 5,
          pinned: true,
          centerTitle: true,
          title: Text('People'),
        ),
        const SliverPadding(padding: EdgeInsets.only(top: 10)),
        _myStoriesGridView(currentUser),
      ],
    );
  }

  Widget _myStoriesGridView(UserData currentUser) {
    return StreamBuilder(
      stream: Helpers.getMyStories(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return const Center(
            child: CircularProgressIndicator(backgroundColor: AppColors.accent),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(child: Text('Error Occured!'));
          } else {
            final _userDocs = snapshot.data!.docs;
            final _item = Provider.of<MyStoryStore>(context);
            _item.setMyStories(_userDocs);
            return MysBody(
              currentUser: currentUser,
              myStories: _item.myStories,
            );
          }
        }
      },
    );
  }
}
