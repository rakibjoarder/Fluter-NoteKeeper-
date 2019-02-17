import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_notkeeper/models/note.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    // Get a location using getDatabasesPath
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'demo.db');

    // open the database
    Database database = await openDatabase(path, version: 1,onCreate: _oncreate);

    return database;
  }

  void _oncreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE note_table (id INTEGER PRIMARY KEY, title TEXT, description Text, priority INTEGER, date Text)");
    print("Table is created");
  }

// Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.db;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query("note_table", orderBy: 'priority ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.db;
    var result = await db.insert("note_table", note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.db;
    var result = await db.update("note_table", note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.db;
    int result = await db.rawDelete('DELETE FROM note_table WHERE id = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.db;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from note_table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNotelist() async{

    List<Note> noteList = new List<Note>();
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

     for(int i=0;i<count;i++){
       noteList.add(Note.fromMapObj(noteMapList[i]));
     }

     return noteList;
  }
}




