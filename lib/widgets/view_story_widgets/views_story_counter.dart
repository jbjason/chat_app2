import 'package:chat_app2/models/my_story.dart';
import 'package:chat_app2/widgets/view_story_widgets/views_appbar_tile.dart';
import 'package:flutter/material.dart';

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
