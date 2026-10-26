import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../widgets/note_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notes = noteProvider.notes;

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes'), centerTitle: true),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'Belum ada catatan.\nTekan + untuk menambahkan catatan.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return NoteCard(
                  note: note,
                  onDelete: () {
                    noteProvider.deleteNote(note.id!);
                  },
                  onTap: () {
                    Navigator.pushNamed(context, '/add-note', arguments: note);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-note');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
