import 'package:chat_app2/models/my_story.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ViewsAppBarTile extends StatelessWidget {
  const ViewsAppBarTile(
      {Key? key, required this.story, required this.selectValue})
      : super(key: key);
  final MyStory story;
  final ValueNotifier<int> selectValue;

  @override
  Widget build(BuildContext context) {
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
        PopupMenuButton(
          onSelected: (_) {},
          icon: const Icon(Icons.more_horiz_sharp, color: Colors.white),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(Icons.delete_sharp),
                  SizedBox(width: 5),
                  Text('delete'),
                ],
              ),
              value: 0,
            ),
          ],
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
