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
  List<Note> filteredPinnedNotes = [];
  List<Note> filteredUnpinnedNotes = [];
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
        _filterNotes();
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
      deletedAt: null,
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
        notes[index] = Note(
          id: id,
          title: newTitle,
          content: newContent,
          isPinned: notes[index].isPinned,
          deletedAt: notes[index].deletedAt,
        );
        _filterNotes();
      }
    });
    saveNotes();
  }

  void deleteNote(String id) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index].deletedAt = DateTime.now(); // soft delete
      }
      _filterNotes();
    });
    saveNotes();
  }

  void togglePin(String id) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index].isPinned = !notes[index].isPinned;
        _filterNotes();
      }
    });
    saveNotes();
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              deleteNote(note.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note moved to Recently Deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

void showNoteDialog([Note? note]) {
  final titleController = TextEditingController(text: note?.title ?? '');
  final contentController = TextEditingController(text: note?.content ?? '');

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note == null ? 'Add Note' : 'Edit Note',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 5,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: Icon(note == null ? Icons.add : Icons.save),
                    label: Text(note == null ? 'Add' : 'Update'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  void _filterNotes() {
    final query = searchController.text.toLowerCase();

    final matching = notes.where((note) =>
        note.deletedAt == null &&
        (note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query))).toList();

    setState(() {
      filteredPinnedNotes = matching.where((n) => n.isPinned).toList();
      filteredUnpinnedNotes = matching.where((n) => !n.isPinned).toList();
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
      appBar: AppBar(
  title: Text('Notes App (${notes.where((n) => n.deletedAt == null).length})'),
),
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
            child: (filteredPinnedNotes.isEmpty && filteredUnpinnedNotes.isEmpty)
                ? const Center(child: Text('No matching notes'))
                : ListView(
                    children: [
                      if (filteredPinnedNotes.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Pinned', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...filteredPinnedNotes.map(
                          (note) => Dismissible(
                            key: Key(note.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              _confirmDelete(note);
                              return false;
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: NoteTile(
                              note: note,
                              onEdit: showNoteDialog,
                              onDelete: (_) => _confirmDelete(note),
                              onTogglePin: togglePin,
                            ),
                          ),
                        ),
                      ],
                      if (filteredUnpinnedNotes.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Others', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...filteredUnpinnedNotes.map(
                          (note) => Dismissible(
                            key: Key(note.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              _confirmDelete(note);
                              return false;
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: NoteTile(
                              note: note,
                              onEdit: showNoteDialog,
                              onDelete: (_) => _confirmDelete(note),
                              onTogglePin: togglePin,
                            ),
                          ),
                        ),
                      ],
                    ],
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
