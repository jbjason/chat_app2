import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/screens/home_screen.dart';
import 'package:chat_app2/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataStore>(context);
    final String _loginStatus = data.getLoginStatus;
    final _userData = data.getUserInfo;
    return _loginStatus == 'signUp'
        ? WelcomeScreen(url: _userData.imageUrl, name: _userData.userName)
        : HomeScreen();
  }
}
