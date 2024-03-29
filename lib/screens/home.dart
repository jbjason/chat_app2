import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/screens/others_screen.dart';
import 'package:chat_app2/screens/welcome_screen.dart';
import 'package:chat_app2/screens/my_story_screen/my_story_screen.dart';
import 'package:chat_app2/screens/message_screen.dart';
import 'package:chat_app2/widgets/common_widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final _pageIndex = ValueNotifier<int>(0);
  final pages = const [
    MessageScreen(),
    MyStoryScreen(),
    OthersPage(),
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
          valueListenable: _pageIndex,
          builder: (BuildContext context, int value, _) => pages[value],
        ),
        bottomNavigationBar:
            NavBar(selectedIndex: _pageIndex.value, onSelect: _changeNavIndex),
      );

  void _changeNavIndex(int i) => _pageIndex.value = i;
}
