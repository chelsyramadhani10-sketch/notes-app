import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'cubits/note_cubit.dart';
import 'repositories/notes_repository.dart';
import 'pages/home_page.dart';
import 'pages/add_note_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notesBox');

  runApp(
    RepositoryProvider(
      create: (context) => NotesRepository(Hive.box('notesBox')),
      child: BlocProvider(
        create: (context) => NoteCubit(context.read<NotesRepository>()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add-note': (context) => const AddNotePage(),
      },
    );
  }
}
