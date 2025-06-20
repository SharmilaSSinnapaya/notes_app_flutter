import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  bool isPinned;
  DateTime? deletedAt;
  Color? color; // 👈 NEW: Add color support

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    this.deletedAt,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'deletedAt': deletedAt?.toIso8601String(),
      'color': color?.value, // 👈 Save color as int
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      isPinned: map['isPinned'] ?? false,
      deletedAt: map['deletedAt'] != null ? DateTime.tryParse(map['deletedAt']) : null,
      color: map['color'] != null ? Color(map['color']) : null,
    );
  }

  // 👇 Optional: copyWith method (useful for editing notes)
  Note copyWith({
    String? id,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? deletedAt,
    Color? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      deletedAt: deletedAt ?? this.deletedAt,
      color: color ?? this.color,
    );
  }
}