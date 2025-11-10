class JournalEntryModel {
  final String id;
  final String userId;
  final String content;
  final String? mood; // e.g., "happy", "sad", "anxious"
  final DateTime createdAt;
  final DateTime? updatedAt;

  JournalEntryModel({
    required this.id,
    required this.userId,
    required this.content,
    this.mood,
    required this.createdAt,
    this.updatedAt,
  });

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      mood: map['mood'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'mood': mood,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}


