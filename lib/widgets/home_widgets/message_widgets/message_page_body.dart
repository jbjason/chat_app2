import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/widgets/home_widgets/message_widgets/custom_appbar.dart';
import 'package:chat_app2/widgets/home_widgets/message_widgets/message_page_list.dart';
import 'package:chat_app2/widgets/home_widgets/message_widgets/stories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBody extends StatelessWidget {
  const MessageBody({
    Key? key,
    required String currentUserId,
    required List<QueryDocumentSnapshot<Object?>> userDocs,
    required this.size,
  })  : _currentUserId = currentUserId,
        _userDocs = userDocs,
        super(key: key);

  final String _currentUserId;
  final List<QueryDocumentSnapshot<Object?>> _userDocs;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final dataStore = Provider.of<DataStore>(context, listen: false);
    return StreamBuilder(
      stream: Helpers.getMsgHistory(_currentUserId),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> msgSnapShot) {
        if (msgSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (msgSnapShot.hasError) {
            return const Center(child: Text('Error Occured!'));
          } else {
            try {
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
