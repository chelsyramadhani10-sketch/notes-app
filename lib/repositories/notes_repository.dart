import 'package:hive/hive.dart';
import '../models/note_model.dart';

class NotesRepository {
  final Box notesBox;

  NotesRepository(this.notesBox);

  List<Note> getAllNotes() {
    final notes = <Note>[];

    for (final key in notesBox.keys) {
      final data = Map<String, dynamic>.from(notesBox.get(key) as Map);

      notes.add(
        Note(
          id: key as int,
          title: data['title'] as String,
          content: data['content'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            data['createdAt'] as int,
          ),
        ),
      );
    }

    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> addNote(Note note) async {
    await notesBox.add({
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<void> updateNote(int id, Note note) async {
    await notesBox.put(id, {
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<void> deleteNote(int id) async {
    await notesBox.delete(id);
  }
}
