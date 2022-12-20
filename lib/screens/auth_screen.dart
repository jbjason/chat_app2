import 'dart:io';
import 'package:chat_app2/constants/constants.dart';
import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/widgets/auth_widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _isLoading = ValueNotifier<bool>(false);
    return Scaffold(
      body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }

  void _submitAuthForm(String email, String pass, String username, File? image,
      bool isLogin, BuildContext ctx, ValueNotifier<bool> isLoad) async {
    UserCredential authResult;
    String message = 'An error occured, please check ur credentials';
    final dataStore = Provider.of<DataStore>(ctx, listen: false);
    final _auth = FirebaseAuth.instance;
    try {
      isLoad.value = true;
      if (isLogin) {
        // this is for showing 'Welcome to chat app purpose'
        dataStore.setLoginStatus('signIn');
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        // this is for showing 'Welcome to chat app purpose'
        dataStore.setLoginStatus('signUp');
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        final ref = FirebaseStorage.instance
            .ref()
            .child('chat_user_image')
            .child(authResult.user!.uid + '.jpg');

        // seeting data's to Cloud database & providers too
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        final date = DateTime.now();
        dataStore.setSignUpUserInfo(
            authResult.user!.uid, username, email, url, date);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userId': authResult.user!.uid,
          'userName': username,
          'email': email,
          'imageUrl': url,
          'lastMsgTime': date.toIso8601String(),
        });
      }
    } on PlatformException catch (err) {
      if (err.message != null) {
        message = err.message!;
      }
      isLoad.value = false;
      getSnackBar(ctx, message, Colors.redAccent);
    } catch (e) {
      isLoad.value = false;
      getSnackBar(ctx, message, Colors.redAccent);
    }
  }
}
