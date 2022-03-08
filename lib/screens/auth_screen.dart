import 'dart:io';

import 'package:chat_app2/widgets/auth_widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  void _submitAuthForm(String emaill, String passwordd, String username,
      File image, bool isLogin, BuildContext ctx) async {
    print(emaill + '\n' + passwordd + '\n' + username);
    print(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
