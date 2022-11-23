import 'package:chat_app2/widgets/auth_widgets/button_login_signup.dart';
import 'package:chat_app2/widgets/auth_widgets/email_textfield.dart';
import 'package:chat_app2/widgets/auth_widgets/pass_textfield.dart';
import 'package:chat_app2/widgets/auth_widgets/signin_text_style.dart';
import 'package:chat_app2/widgets/auth_widgets/signup_text_style.dart';
import 'package:chat_app2/widgets/auth_widgets/username_textfield.dart';
import 'package:chat_app2/widgets/common_widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AuthForm({required this.submitFn, required this.isLoading});

  final Function(String email, String password, String userName, File image,
      bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passController = TextEditingController();
  File? _userImageFile;

  void _pickedImage(File image) => _userImageFile = image;

  void changeLoginStatus() => setState(() => _isLogin = !_isLogin);

  void trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please pick an image')));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _emailController.text.trim(),
        _passController.text.trim(),
        _userNameController.text.trim(),
        _userImageFile != null ? _userImageFile! : File(''),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10),
        decoration: _decoration,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // signIn & signUp text
                _isLogin ? const SignInTextStyle() : const SignUpTextStyle(),
                // image Picker
                if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                // TextFields & buttons
                Padding(
                  padding: const EdgeInsets.only(
                      left: 56, right: 16, top: 10, bottom: 16),
                  child: Column(
                    children: [
                      EmailTextField(emailController: _emailController),
                      if (!_isLogin)
                        UserNameTextField(
                            userNameController: _userNameController),
                      PassTextField(passController: _passController),
                      ButtonloginSignup(
                        trySubmit: trySubmit,
                        changeLoginStatus: changeLoginStatus,
                        isLoading: widget.isLoading,
                        isLogin: _isLogin,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF033D49),
        Color(0xFF104F55),
        Color(0xFF155C60),
        Color(0xFF186568),
        Color(0xFF1B6F72),
        Color(0xFF1F787A),
      ],
    ),
  );
}
