import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/message_data.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/chat_screen.dart';
import 'package:chat_app2/widgets/common_widgets/icon_background.dart';
import 'package:chat_app2/widgets/message_widgets/message_search.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class MessageAppBar extends StatelessWidget {
  const MessageAppBar({
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
      // search Icon
      leading: _imageIcon(),
      title: Text('Messages', style: Theme.of(context).textTheme.headline1),
      actions: [
        _searchIcon(context),
        const SizedBox(width: 6),
        _themeIcon(context),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _imageIcon() => Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: currentUserIndex != -1
            ? CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(users[currentUserIndex].imageUrl),
              )
            : const CircleAvatar(radius: 18),
      );

  Widget _themeIcon(BuildContext ctx) => Consumer<ThemeProvider>(
        builder: (_, theme, __) {
          final f = theme.getTheme == AppTheme.light();
          return Center(
            child: IconBorder(
              icon: f ? Icons.dark_mode_outlined : Icons.dark_mode,
              onTap: () {
                Provider.of<ThemeProvider>(ctx, listen: false).switchTheme();
              },
            ),
          );
        },
      );

  Widget _searchIcon(BuildContext context) => Center(
        child: IconBorder(
          icon: Icons.search,
          onTap: () async {
            final f = await showSearch(
                context: context, delegate: MessageSearch(users: users));
            if (f != null) {
              // .toString cz Jeff pckg expects String
              final msg = f.lastMsgTime.toString().toString();
              final String difference = Jiffy(DateTime.parse(msg)).fromNow();
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
                        img: f.imageUrl),
                  ),
                ),
              );
            }
          },
        ),
      );
}
