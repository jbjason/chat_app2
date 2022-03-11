class MessageData {
  const MessageData({
    required this.userName,
    required this.userId,
    required this.message,
    required this.messageDate,
    required this.dateDifference,
    required this.img,
  });
  final String userName;
  final String userId;
  final String message;
  final DateTime messageDate;
  final String dateDifference;
  final String img;
}
