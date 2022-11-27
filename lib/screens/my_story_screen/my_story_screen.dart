import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/widgets/my_story_widgets/my_story_item.dart';
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
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => MyStoryItem(
              index: index,
              currentUser: currentUser,
            ),
            childCount: 10,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .79,
          ),
        )
      ],
    );
  }
}
