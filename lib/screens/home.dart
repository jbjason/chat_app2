import 'package:chat_app2/constants/data_store.dart';
import 'package:chat_app2/screens/auth_screen.dart';
import 'package:chat_app2/screens/home_screen.dart';
import 'package:chat_app2/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _loginStatus =
        Provider.of<DataStore>(context, listen: false).getLoginStatus;
    return _loginStatus == 'signUp'
        ? const WelcomeScreen()
        : _loginStatus == 'logOut'
            ? const AuthScreen()
            : HomeScreen();
  }
}
