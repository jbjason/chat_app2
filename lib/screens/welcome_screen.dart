import 'package:chat_app2/constants/data_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key, required this.url, required this.name})
      : super(key: key);

  final String url, name;
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;
  int i = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (i != 0) return;
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  void initializeMsgHistory() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Provider.of<DataStore>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(widget.url),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 20, bottom: 10),
                        child: const Text(
                          'You\'re now signed in as',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${widget.name} on ChatApp!',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
          Container(
            height: 65,
            margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
            width: size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[850],
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    child: const Text('CONTINUE',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    onPressed: () {
                      data.setLoginStatus('');
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
