import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Note? _existingNote;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _existingNote = ModalRoute.of(context)?.settings.arguments as Note?;

      if (_existingNote != null) {
        _titleController.text = _existingNote!.title;
        _contentController.text = _existingNote!.content;
      }

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi catatan harus diisi!')),
      );
      return;
    }

    final provider = context.read<NoteProvider>();

    if (_existingNote == null) {
      final newNote = Note(
        id: DateTime.now().microsecondsSinceEpoch,
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );

      provider.addNote(newNote);
    } else {
      final updatedNote = Note(
        id: _existingNote!.id,
        title: title,
        content: content,
        createdAt: _existingNote!.createdAt,
      );

      provider.updateNote(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingNote != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'Add New Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                child: Text(isEditing ? 'Update Note' : 'Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
