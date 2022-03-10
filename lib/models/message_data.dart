class MessageData {
  const MessageData({
    required this.senderName,
    required this.senderId,
    required this.message,
    required this.messageDate,
    required this.dateDifference,
    required this.profilePicture,
  });
  final String senderName;
  final String senderId;
  final String message;
  final DateTime messageDate;
  final String dateDifference;
  final String profilePicture;
}
