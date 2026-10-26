import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/note_model.dart';
import '../repositories/notes_repository.dart';

class NoteCubit extends Cubit<List<Note>> {
  final NotesRepository _repository;

  NoteCubit(this._repository) : super(_repository.getAllNotes());

  Future<void> addNote(Note note) async {
    await _repository.addNote(note);
    emit(_repository.getAllNotes());
  }

  Future<void> updateNote(Note note) async {
    final id = note.id;
    if (id == null) return;

    await _repository.updateNote(id, note);
    emit(_repository.getAllNotes());
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    emit(_repository.getAllNotes());
  }
}
