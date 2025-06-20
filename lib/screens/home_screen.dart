import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../widgets/note_tile.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
    searchController.addListener(_filterNotes);
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes = prefs.getString('notes');

    if (savedNotes != null) {
      final List decoded = jsonDecode(savedNotes);
      final loadedNotes = decoded.map((data) => Note.fromMap(data)).toList();

      setState(() {
        notes = loadedNotes;
        filteredNotes = loadedNotes;
      });
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notes.map((n) => n.toMap()).toList());
    prefs.setString('notes', encoded);
  }

  void addNote(String title, String content) {
    final note = Note(
      id: Random().nextDouble().toString(),
      title: title,
      content: content,
    );
    setState(() {
      notes.add(note);
      _filterNotes();
    });
    saveNotes();
  }

  void updateNote(String id, String newTitle, String newContent) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index] = Note(id: id, title: newTitle, content: newContent);
        _filterNotes();
      }
    });
    saveNotes();
  }

  void deleteNote(String id) {
    setState(() {
      notes.removeWhere((note) => note.id == id);
      _filterNotes();
    });
    saveNotes();
  }

  void showNoteDialog([Note? note]) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              if (title.isEmpty || content.isEmpty) return;

              if (note == null) {
                addNote(title, content);
              } else {
                updateNote(note.id, title, content);
              }

              Navigator.of(ctx).pop();
            },
            child: Text(note == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _filterNotes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes App')),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('No matching notes'))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (ctx, i) {
                      final note = filteredNotes[i];
                      return Dismissible(
                        key: Key(note.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          deleteNote(note.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Note deleted')),
                          );
                        },
                        child: NoteTile(
                          note: note,
                          onEdit: showNoteDialog,
                          onDelete: deleteNote, // This shows the trailing delete button
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
