import 'package:chat_app2/models/user_data.dart';
import 'package:flutter/cupertino.dart';

class SearchStore with ChangeNotifier {
  List<UserData> _hintsList = [];
  List<UserData> _searchList = [];

  void setSearchList(List<UserData> u) {
    _searchList = u;
    notifyListeners();
  }

  void setHintsList(List<UserData> u) {
    _hintsList = u;
    notifyListeners();
  }

  List<UserData> get searchList {
    return [..._searchList];
  }

  List<UserData> get hintsList {
    return [..._hintsList];
  }
}
