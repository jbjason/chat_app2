class UserData {
  final String userId, userName, imageUrl, email;
  final DateTime lastMsgTime;
  final String lastMsg;

  const UserData({
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.email,
    required this.lastMsgTime,
    required this.lastMsg,
  });
}