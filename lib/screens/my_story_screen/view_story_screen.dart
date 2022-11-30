import 'package:chat_app2/models/my_story.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ViewStoryScreen extends StatelessWidget {
  const ViewStoryScreen({Key? key, required this.story}) : super(key: key);
  final MyStory story;

  @override
  Widget build(BuildContext context) {
    final _selected = ValueNotifier<int>(0);
    final _data = MediaQuery.of(context);
    final _topPadding = _data.padding.top;
    final _width = _data.size.width - 10;
    final _itemWidth = _width / story.storyItem.length;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: PageView.builder(
              onPageChanged: (val) => _selected.value = val,
              itemCount: story.storyItem.length,
              itemBuilder: (context, index) =>
                  Image.network(story.storyItem[index].img, fit: BoxFit.cover),
            ),
          ),
          ViewsShadow(topPadding: _topPadding),
          ViewsStoryCounter(
            topPadding: _topPadding,
            story: story,
            selected: _selected,
            itemWidth: _itemWidth,
          ),
        ],
      ),
    );
  }
}

class ViewsStoryCounter extends StatelessWidget {
  const ViewsStoryCounter({
    Key? key,
    required double topPadding,
    required this.story,
    required ValueNotifier<int> selected,
    required double itemWidth,
  })  : _topPadding = topPadding,
        _selected = selected,
        _itemWidth = itemWidth,
        super(key: key);

  final double _topPadding;
  final MyStory story;
  final ValueNotifier<int> _selected;
  final double _itemWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topPadding + 5,
      left: 5,
      right: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: List.generate(
              story.storyItem.length,
              (index) => ValueListenableBuilder(
                valueListenable: _selected,
                builder: (context, int selected, _) {
                  final _isSelect = index == selected;
                  return Container(
                    height: _isSelect ? 6 : 3,
                    margin: const EdgeInsets.only(right: 2),
                    width: _itemWidth - 2,
                    color: _isSelect ? Colors.white : Colors.grey,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          ViewsAppBarTile(story: story, selectValue: _selected)
        ],
      ),
    );
  }
}

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

class ViewsShadow extends StatelessWidget {
  const ViewsShadow({Key? key, required this.topPadding}) : super(key: key);
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPadding,
      left: 0,
      right: 0,
      height: 60,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 20,
              blurRadius: 40,
              color: Colors.black38,
            )
          ],
        ),
      ),
    );
  }
}
