import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/widgets/view_story_widgets/views_shadow.dart';
import 'package:chat_app2/widgets/view_story_widgets/views_story_counter.dart';
import 'package:flutter/material.dart';

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
        clipBehavior: Clip.none,
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
