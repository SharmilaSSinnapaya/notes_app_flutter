class Note {
  String id;
  String title;
  String content;
  bool isPinned;
  DateTime? deletedAt; // ← NEW: for recently deleted support

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    this.deletedAt,
  });

  // Convert Note to Map (for saving to storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  // Create Note from Map (for loading from storage)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isPinned: map['isPinned'] ?? false,
      deletedAt: map['deletedAt'] != null
          ? DateTime.tryParse(map['deletedAt'])
          : null,
    );
  }
}
