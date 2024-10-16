class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, required this.timestamp});

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      text: data['text'],
      isUser: data['isUser'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}