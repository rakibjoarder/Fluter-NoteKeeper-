import 'package:flutter/material.dart';
import 'package:flutter_notkeeper/Pages/note_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: NoteList(),
    );
  }
}
