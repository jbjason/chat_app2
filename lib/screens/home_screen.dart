import 'package:chat_app2/pages/calls_page.dart';
import 'package:chat_app2/pages/contacts_page.dart';
import 'package:chat_app2/pages/messages_page.dart';
import 'package:chat_app2/pages/notifications_page.dart';
import 'package:chat_app2/widgets/home_widgets/home_navbar.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final pages = const [
    MessagesPage(),
    NotificationsPage(),
    CallsPage(),
    ContactsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: HomeNavBar(
        onItemSelected: (index) => pageIndex.value = index,
      ),
    );
  }
}
