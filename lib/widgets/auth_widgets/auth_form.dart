import 'package:chat_app2/constants/theme.dart';
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
  String _userEmail = '', _userName = '', _userPassword = '';
  File? _userImageFile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                  _emailTextField(),
                  if (!_isLogin) _userNameTextField(),
                  _passwordTextField(),
                  _loginSignupButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please pick an image')));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImageFile!, _isLogin, context);
    }
  }

  Widget _emailTextField() {
    return TextFormField(
      key: const ValueKey('email'),
      decoration: const InputDecoration(labelText: 'Email Address'),
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        _userEmail = value!;
      },
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _userNameTextField() {
    return TextFormField(
      key: const ValueKey('username'),
      decoration: const InputDecoration(labelText: 'Username'),
      onSaved: (value) {
        _userName = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter atleast 4 characters';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      key: const ValueKey('password'),
      decoration: const InputDecoration(labelText: 'password'),
      obscureText: true,
      onSaved: (value) {
        _userPassword = value!;
      },
      validator: (value) {
        if (value!.isEmpty || value.length <= 5) {
          return 'Please enter atleast 4 characters';
        }
        return null;
      },
    );
  }

  Widget _loginSignupButton() {
    return Column(
      children: [
        widget.isLoading
            ? const CircularProgressIndicator()
            : Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'Signup',
                        style: const TextStyle(color: Colors.white))),
              ),
        if (!widget.isLoading)
          TextButton(
            onPressed: () {
              setState(() => _isLogin = !_isLogin);
            },
            child: Text(
              _isLogin ? 'Create new account' : 'I already have an account',
              style: const TextStyle(color: AppColors.textLigth),
            ),
          )
      ],
    );
  }
}
