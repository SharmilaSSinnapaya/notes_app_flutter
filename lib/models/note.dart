class Note {
  String id;
  String title;
  String content;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false, // default to unpinned
  });

  // Convert Note to Map (for saving to storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isPinned': isPinned,
    };
  }

  // Create Note from Map (for loading from storage)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isPinned: map['isPinned'] ?? false,
    );
  }
}