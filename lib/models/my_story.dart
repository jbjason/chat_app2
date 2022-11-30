class MyStory {
  final String id;
  final String userId;
  final String userName;
  final String userImg;
  final List<MyStoryItem> storyItem;

  const MyStory({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImg,
    required this.storyItem,
  });
}

class MyStoryItem {
  final String img;
  final DateTime dateTime;
  const MyStoryItem({required this.img, required this.dateTime});
}
