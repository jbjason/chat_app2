import 'package:chat_app2/provider/data_store.dart';
import 'package:chat_app2/provider/mystory_store.dart';
import 'package:chat_app2/provider/search_store.dart';
import 'package:chat_app2/screens/auth_screen.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => DataStore()),
        ChangeNotifierProvider(create: (ctx) => SearchStore()),
        ChangeNotifierProvider(create: (ctx) => MyStoryStore()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App2',
          theme: theme.getTheme,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapShot) {
              if (userSnapShot.hasData) {
                return Home();
              } else {
                return const AuthScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
