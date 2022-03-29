import 'package:chat_app2/models/user_data.dart';
import 'package:flutter/cupertino.dart';

class SearchStore with ChangeNotifier {
  final List<UserData> _hintsList = [];

  void setHintsList(UserData u) {
    _hintsList.add(u);
  }

  List<UserData> get hintsList {
    return [..._hintsList];
  }
}
