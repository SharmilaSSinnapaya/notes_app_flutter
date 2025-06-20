class Note {
  String id;
  String title;
  String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });

  // Convert Note to Map (for saving)
  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Create Note from Map (for loading)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
