import 'package:chat_app2/constants/theme.dart';
import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/provider/mystory_store.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class ViewsAppBarTile extends StatelessWidget {
  const ViewsAppBarTile(
      {Key? key, required this.story, required this.selectValue})
      : super(key: key);
  final MyStory story;
  final ValueNotifier<int> selectValue;

  @override
  Widget build(BuildContext context) {
    final _isLoading = ValueNotifier<bool>(false);
    return Row(
      children: [
        const SizedBox(width: 5),
        CircleAvatar(
          radius: 19.5,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(story.userImg),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.userName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder(
                valueListenable: selectValue,
                builder: (context, int selected, _) {
                  final _date = story.storyItem[selected].dateTime;
                  final _parse = DateTime.parse(_date.toString());
                  final _dateDifference = Jiffy(_parse).fromNow();
                  return Text(
                    _dateDifference,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, bool isLoading, _) {
            return isLoading
                ? const CircularProgressIndicator(color: AppColors.accent)
                : _logOutButton(context, _isLoading);
          },
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _logOutButton(BuildContext context, ValueNotifier<bool> _isLoading) =>
      PopupMenuButton(
        onSelected: (_) async {
          _isLoading.value = true;
          await Provider.of<MyStoryStore>(context, listen: false)
              .deleteStory(story, selectValue.value);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.more_horiz_sharp, color: Colors.white),
        itemBuilder: (_) => [
          PopupMenuItem(
            child: Row(
              children: const [
                SizedBox(width: 5),
                Icon(Icons.delete_sharp),
                SizedBox(width: 8),
                Text('delete'),
                SizedBox(width: 5),
              ],
            ),
            value: 0,
          ),
        ],
      );
}
