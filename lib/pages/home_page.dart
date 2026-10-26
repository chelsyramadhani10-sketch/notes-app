import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/note_cubit.dart';
import '../models/note_model.dart';
import '../widgets/note_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes'), centerTitle: true),
      body: BlocBuilder<NoteCubit, List<Note>>(
        builder: (context, notes) {
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada catatan.\nTekan + untuk menambahkan catatan.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return NoteCard(
                note: note,
                onDelete: () {
                  context.read<NoteCubit>().deleteNote(note.id!);
                },
                onTap: () {
                  Navigator.pushNamed(context, '/add-note', arguments: note);
                },
              );
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
