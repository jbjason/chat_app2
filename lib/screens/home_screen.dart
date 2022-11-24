import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/screens/welcome_screen.dart';
import 'package:chat_app2/pages/calls_page.dart';
import 'package:chat_app2/pages/mystory_page.dart';
import 'package:chat_app2/pages/messages_page.dart';
import 'package:chat_app2/pages/notifications_page.dart';
import 'package:chat_app2/widgets/common_widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final pages = const [
    MessagesPage(),
    NotificationsPage(),
    CallsPage(),
    MyStoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataStore>(context);
    final String _loginStatus = data.getLoginStatus;
    final _userData = data.getUserInfo;
    return _loginStatus == 'signUp'
        ? WelcomeScreen(url: _userData.imageUrl, name: _userData.userName)
        : _chatHomeScreen();
  }

  Widget _chatHomeScreen() => Scaffold(
        body: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (BuildContext context, int value, _) {
            return pages[value];
          },
        ),
        bottomNavigationBar: NavBar(
          onItemSelected: (index) => pageIndex.value = index,
        ),
      );
}
