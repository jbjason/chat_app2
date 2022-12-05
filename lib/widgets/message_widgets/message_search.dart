import 'package:chat_app2/models/user_data.dart';
import 'package:chat_app2/provider/search_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageSearch extends SearchDelegate {
  MessageSearch({required this.users});
  final List<UserData> users;

  @override
  List<Widget>? buildActions(BuildContext context) {
    try {
      return [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
      ];
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(CupertinoIcons.back));
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    final data = Provider.of<SearchStore>(context, listen: false);
    final List<UserData> _hints = data.hintsList;
    final searchList = query.isEmpty
        ? _hints
        : users.where((p) {
            final cityLower = p.userName.toLowerCase();
            final queryLower = query.toLowerCase();
            return cityLower.startsWith(queryLower);
          }).toList();
    return ListView.builder(
      padding: const EdgeInsets.only(left: 14, right: 10),
      itemBuilder: (context, index) => Card(
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ListTile(
          onTap: () {
            data.setHintsList(searchList[index]);
            close(context, searchList[index]);
          },
          leading: CircleAvatar(
            radius: 13,
            backgroundImage: NetworkImage(searchList[index].imageUrl),
          ),
          title: RichText(
            text: TextSpan(
                text: searchList[index].userName.substring(0, query.length),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: searchList[index].userName.substring(query.length),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
      itemCount: searchList.length,
    );
  }
}
