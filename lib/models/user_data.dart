class UserData {
  final String userId;
  final String userName;
  final String imageUrl;
  final String email;
  DateTime lastMsgTime;
  final String lastMsg;

  UserData({
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.email,
    required this.lastMsgTime,
    required this.lastMsg,
  });
}
