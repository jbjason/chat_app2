import 'dart:io';
import 'package:chat_app2/widgets/auth_widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    try {
      setState(() => _isLoading = true);
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: emaill, password: passwordd);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: emaill, password: passwordd);
        final ref = FirebaseStorage.instance
            .ref()
            .child('chat_user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userId': authResult.user!.uid,
          'userName': username,
          'email': emaill,
          'imageUrl': url,
          'lastMsgTime': DateTime.now().toIso8601String(),
          'lastMsg': '',
        });
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
