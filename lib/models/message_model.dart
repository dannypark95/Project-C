class MessageModel {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      isFromUser: map['isFromUser'] ?? true,
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp,
    };
  }
}


