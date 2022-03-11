import 'package:chat_app2/constants/helpers.dart';
import 'package:chat_app2/screens/auth_screen.dart';
import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/screens/home_screen.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: ChangeNotifierProvider(
        create: (context) => DataStore(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.hasData) {
              return HomeScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
