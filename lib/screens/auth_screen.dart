import 'dart:io';
import 'package:chat_app2/constants/data_store.dart';
import 'package:chat_app2/widgets/auth_widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }

  void _submitAuthForm(String emaill, String passwordd, String username,
      File? image, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    final dataStore = Provider.of<DataStore>(context, listen: false);
    try {
      setState(() => _isLoading = true);
      if (isLogin) {
        dataStore.setLoginStatus('signIn');
        authResult = await _auth.signInWithEmailAndPassword(
            email: emaill, password: passwordd);
      } else {
        dataStore.setLoginStatus('signUp');
        authResult = await _auth.createUserWithEmailAndPassword(
            email: emaill, password: passwordd);
        final ref = FirebaseStorage.instance
            .ref()
            .child('chat_user_image')
            .child(authResult.user!.uid + '.jpg');

        // seeting data's to Cloud database & providers too
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        final date = DateTime.now();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userId': authResult.user!.uid,
          'userName': username,
          'email': emaill,
          'imageUrl': url,
          'lastMsgTime': date.toIso8601String(),
        });
        dataStore.setSignUpUserInfo(
            authResult.user!.uid, username, emaill, url, date);
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check ur credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor),
      );
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
}
