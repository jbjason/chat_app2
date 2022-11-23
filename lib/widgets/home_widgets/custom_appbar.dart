import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/provider/search_store.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

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
          onTap: () async {
            final f = await showSearch(
                context: context, delegate: _Delegate(users: users));
            if (f != null) {
              final String difference =
                  Jiffy(DateTime.parse(f.lastMsgTime.toString().toString()))
                      .fromNow();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                      currentUser: users[currentUserIndex],
                      messageData: MessageData(
                          userId: f.userId,
                          userName: f.userName,
                          message: f.lastMsg,
                          dateDifference: difference,
                          img: f.imageUrl)),
                ),
              );
            }
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
        InkWell(
          onTap: () => FirebaseAuth.instance.signOut(),
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 3),
            child: currentUserIndex != -1
                ? CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        NetworkImage(users[currentUserIndex].imageUrl),
                  )
                : const CircleAvatar(radius: 18),
          ),
        ),
      ],
    );
  }
}

class _Delegate extends SearchDelegate {
  _Delegate({required this.users});
  final List<UserData> users;

  @override
  List<Widget>? buildActions(BuildContext context) {
    try {
      return [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
      ];
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(CupertinoIcons.back));
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    final data = Provider.of<SearchStore>(context, listen: false);
    final List<UserData> _hints = data.hintsList;
    final searchList = query.isEmpty
        ? _hints
        : users.where((p) {
            final cityLower = p.userName.toLowerCase();
            final queryLower = query.toLowerCase();
            return cityLower.startsWith(queryLower);
          }).toList();
    return ListView.builder(
      padding: const EdgeInsets.only(left: 14, right: 10),
      itemBuilder: (context, index) => Card(
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ListTile(
          onTap: () {
            data.setHintsList(searchList[index]);
            close(context, searchList[index]);
          },
          leading: CircleAvatar(
            radius: 13,
            backgroundImage: NetworkImage(searchList[index].imageUrl),
          ),
          title: RichText(
            text: TextSpan(
                text: searchList[index].userName.substring(0, query.length),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: searchList[index].userName.substring(query.length),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
      itemCount: searchList.length,
    );
  }
}
