import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/provider/data_store.dart';
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

class MyStoryItem extends StatelessWidget {
  const MyStoryItem({Key? key, required this.index, required this.currentUser})
      : super(key: key);
  final int index;
  final UserData currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: index == 0
            ? BoxDecoration(
                color: Colors.teal[100 * (index % 9)],
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                    image: NetworkImage(currentUser.imageUrl),
                    fit: BoxFit.cover))
            : BoxDecoration(
                color: Colors.teal[100 * (index % 9)],
                borderRadius: BorderRadius.circular(14),
              ),
        child: index == 0 ? _currentUserInfo() : _friendUserInfo());
  }

  Widget _friendUserInfo() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // CircleAvatar(
          //   radius: 22,
          //   backgroundImage: AssetImage('assets/travel/offer1.jpg'),
          // ),
          Text(
            'Jb Jason',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _currentUserInfo() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CircleAvatar(
            radius: 18,
            child: Icon(Icons.add),
          ),
          Text(
            'Add to Story',
            style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
}
