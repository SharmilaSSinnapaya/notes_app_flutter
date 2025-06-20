import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final void Function(Note note) onEdit;
  final void Function(String id) onDelete;
  final void Function(String id) onTogglePin;

  const NoteTile({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      color: note.color ?? theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        title: Text(
          note.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            note.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.75),
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.amber,
              ),
              tooltip: note.isPinned ? 'Unpin' : 'Pin',
              onPressed: () => onTogglePin(note.id),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.blueAccent,
              tooltip: 'Edit Note',
              onPressed: () => onEdit(note),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.redAccent,
              tooltip: 'Delete Note',
              onPressed: () => onDelete(note.id),
            ),
          ],
        ),
        onTap: () => onEdit(note),
      ),
    );
  }
}