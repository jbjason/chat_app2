import 'package:chat_app2/constants/data_store.dart';
import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/models/story_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:chat_app2/widgets/home_widgets/message_list.dart';
import 'package:chat_app2/widgets/home_widgets/stories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dataStore = Provider.of<DataStore>(context, listen: false);
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
            return StreamBuilder(
              stream: Helpers.getMsgHistory(_currentUserId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> msgSnapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapShot.hasError) {
                    return const Center(child: Text('Error Occured!'));
                  } else {
                    try {
                      final _userDocs = snapShot.data!.docs;
                      final _msgHistoryDocs = msgSnapShot.data!.docs;
                      dataStore.setUsersWithDate(
                          _userDocs, _msgHistoryDocs, _currentUserId);
                      final _notSortedUsersList = dataStore.usersList;
                      final _usersList = dataStore.sortedUsersList;
                      final _currentUserIndex =
                          dataStore.findCurrentUserIndex(_currentUserId);
                      return CustomScrollView(
                        slivers: [
                          //appBar
                          CustomAppBar(
                              currentUserIndex: _currentUserIndex,
                              users: _notSortedUsersList),
                          // Stories
                          Stories(
                              userDocs: _notSortedUsersList,
                              loggedInUser: _currentUserId,
                              size: size),
                          // Messages List
                          MessageList(
                              usersList: _usersList,
                              currentUserIndex: _currentUserIndex,
                              currentUserId: _currentUserId),
                        ],
                      );
                    } catch (e) {
                      return Container();
                    }
                  }
                }
              },
            );
          }
        }
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.currentUserIndex,
    required this.users,
  }) : super(key: key);
  final List<UserData> users;
  final int currentUserIndex;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: kToolbarHeight + 5,
      pinned: true,
      centerTitle: true,
      leadingWidth: 54,
      leading: Align(
        alignment: Alignment.centerRight,
        child: IconBackground(
          icon: Icons.search,
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
      title: const Text(
        'Messages',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0, top: 3),
          child: currentUserIndex != -1
              ? CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage(users[currentUserIndex].imageUrl),
                )
              : const CircleAvatar(radius: 18),
        ),
      ],
    );
  }
}
