import 'package:chat_app2/constants/data_store.dart';
import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late UserData _currentUser;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _currentUser = Provider.of<DataStore>(context, listen: false).getUserInfo;
    _initializeMsgHistory();
  }

  void _initializeMsgHistory() async {
    // final _userDocs =
    //     await FirebaseFirestore.instance.collection('users').get();
    // final _users = _userDocs.docs;
    // for (int i = 0; i < _users.length; i++) {
    //   if (_currentUser.userId != _users[i]['userId']) {
    //     await FirebaseFirestore.instance
    //         .collection('msgHistory')
    //         .doc(_currentUser.userId)
    //         .collection('user')
    //         .doc(_users[i]['userId'])
    //         .set({
    //       'lastMsg': '',
    //       'lastMsgTime': _currentUser.lastMsgTime.toIso8601String(),
    //       'userId': _users[i]['userId'],
    //     });
    //   }
    // }
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(_currentUser.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'You\'re now signed in as ${_currentUser.userName} on ChatApp!',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    child: const Text('CONTINUE'),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
