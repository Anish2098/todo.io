import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/model/todo_model.dart';

class DatabaseProvider {
  static Database? _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();

  Future<Database?> get database async {
    // if database exists,return database
    if (_database != null) {
      return _database;
    }
    //if( database don't eists,create one
    _database = await initDB();

    return _database;
  }

// Create the database and Login Table
  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    // For Login_Model  Database
    final path = join(documentDirectory.path, 'ToDo.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE ToDo('
              'age INTEGER,'
              'first_name TEXT,'
              'last_name TEXT,'
              'occupation TEXT'
              ')');

        });
  }

  // Insert ToDoData in Database
  createTodo(TodoModel todo) async {
    final db = await database;
    var res = await db?.insert("ToDo", todo.toMap());
    print("insert data into database");
    return res;
  }


// Delete One Data
  deleteToDo(String first_name) async {
    final db = await database;
    db!.delete("ToDo", where: "first_name = ?", whereArgs: [first_name]);
    print("deleted data from database");
  }


  // Show All ToDoData from Database

  getAllToDo() async {
    final db = await database;
    var res = await db!.query("ToDo");
    List<TodoModel> list =
    res.isNotEmpty ? res.map((c) => TodoModel.fromMap(c)).toList() : [];
    print("get All data from database");
    return list;
  }

  // update  ToDoData in Database
  updateToDo(TodoModel newToDo) async {
    final db = await database;
    var res = await db!.update("ToDo", newToDo.toMap(),

        where: "first_name = ?", whereArgs: [newToDo.first_name]);
    print(newToDo.first_name);
    print(res);
    print("update  data into database");
    return res;
  }

}

