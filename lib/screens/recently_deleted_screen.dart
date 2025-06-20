import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/note.dart';

class RecentlyDeletedScreen extends StatefulWidget {
  const RecentlyDeletedScreen({super.key});

  @override
  State<RecentlyDeletedScreen> createState() => _RecentlyDeletedScreenState();
}

class _RecentlyDeletedScreenState extends State<RecentlyDeletedScreen> {
  List<Note> deletedNotes = [];

  @override
  void initState() {
    super.initState();
    loadDeletedNotes();
  }

  Future<void> loadDeletedNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes = prefs.getString('notes');

    if (savedNotes != null) {
      final List decoded = jsonDecode(savedNotes);
      final loadedNotes = decoded.map((data) => Note.fromMap(data)).toList();

      setState(() {
        deletedNotes = loadedNotes
            .where((note) => note.deletedAt != null)
            .toList()
          ..sort((a, b) => b.deletedAt!.compareTo(a.deletedAt!)); // newest first
      });
    }
  }

  Future<void> saveNotes(List<Note> allNotes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(allNotes.map((n) => n.toMap()).toList());
    await prefs.setString('notes', encoded);
    loadDeletedNotes();
  }

  Future<void> restoreNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes = prefs.getString('notes');

    if (savedNotes != null) {
      final List decoded = jsonDecode(savedNotes);
      final allNotes = decoded.map((data) => Note.fromMap(data)).toList();

      final index = allNotes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        allNotes[index].deletedAt = null;
      }

      await saveNotes(allNotes);
    }
  }

  Future<void> permanentlyDelete(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes = prefs.getString('notes');

    if (savedNotes != null) {
      final List decoded = jsonDecode(savedNotes);
      final allNotes = decoded.map((data) => Note.fromMap(data)).toList();

      allNotes.removeWhere((n) => n.id == note.id);

      await saveNotes(allNotes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recently Deleted')),
      body: deletedNotes.isEmpty
          ? const Center(child: Text('No recently deleted notes'))
          : ListView.builder(
              itemCount: deletedNotes.length,
              itemBuilder: (ctx, i) {
                final note = deletedNotes[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'restore') {
                          restoreNote(note);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Note restored')),
                          );
                        } else if (value == 'delete') {
                          permanentlyDelete(note);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Note permanently deleted')),
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'restore',
                          child: Text('Restore'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Permanently'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
