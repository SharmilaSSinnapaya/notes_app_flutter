import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        color: note.color ?? theme.colorScheme.background,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(
              color: theme.dividerColor.withOpacity(0.4),
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onBackground.withOpacity(0.9),
                  ),
                ),
              ),
            ),

            // Timestamp or footer
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Created: ${DateTime.now().toLocal().toString().split('.')[0]}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
