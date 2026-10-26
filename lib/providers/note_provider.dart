import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/note_model.dart';
import '../repositories/notes_repository.dart';

class NoteProvider extends ChangeNotifier {
  late final NotesRepository _repository;
  List<Note> _notes = [];

  NoteProvider() {
    _repository = NotesRepository(Hive.box('notesBox'));
    _loadNotes();
  }

  List<Note> get notes => List.unmodifiable(_notes);

  void _loadNotes() {
    _notes = _repository.getAllNotes();

    debugPrint('Jumlah catatan di Hive: ${_notes.length}');
    debugPrint('Isi catatan: ${_notes.map((n) => n.title).toList()}');

    notifyListeners();
  }

  Future<void> addNote(Note newNote) async {
    await _repository.addNote(newNote);

    debugPrint('Data berhasil disimpan ke Hive');
    debugPrint('Isi Hive: ${Hive.box('notesBox').toMap()}');

    _loadNotes();
  }

  Future<void> updateNote(Note updatedNote) async {
    final id = updatedNote.id;
    if (id == null) return;

    await _repository.updateNote(id, updatedNote);
    _loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    _loadNotes();
  }
}
