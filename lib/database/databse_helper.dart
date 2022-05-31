import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import '../models/todo_model.dart';
import '../models/todolist_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  ///Fields of the TodoListsTable ----------------------------------------------
  static const String todoListsTableName = 'todoliststable';
  static const String todoListsTableFieldId = 'id';
  static const String todoListsTableFieldListName =
      'listName'; //i.E. Workout exercises
  static const String todoListsTableFieldCategory =
      'category'; //i.E. 'Work' or 'Nutrition'

  ///Fields of the TodosTable --------------------------------------------------
  static const String todosTableName = 'todostable';
  static const String todosTableFieldId = 'id';
  static const String todosTableFieldTask = 'task'; //i.E. '100 Situps'
  static const String todosTableFieldAccomplished = 'accomplished';
  static const String todosTableFieldRepetitionPeriod = 'repetitionperiod';
  static const String todosTableFieldTodoListId = 'todolistid';
  static const String todosTableFieldaccomplishedAt = 'accomplishedAt';

  ///Other TodolistModel variables ---------------------------------------------
  static const String numberOfTodos = 'numberOfTodos';
  static const String numberOfAccomplishedTodos = 'numberOfAccomplishedTodos';
  static const String todos = 'todos';

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $todoListsTableName(
          $todoListsTableFieldId INTEGER PRIMARY KEY AUTOINCREMENT,
          $todoListsTableFieldListName TEXT,
          $todoListsTableFieldCategory INTEGER
      );
      ''');
    await db.execute('''
      CREATE TABLE $todosTableName(
          $todosTableFieldId INTEGER PRIMARY KEY AUTOINCREMENT,
          $todosTableFieldTask TEXT,
          $todosTableFieldAccomplished INTEGER,
          $todosTableFieldRepetitionPeriod INTEGER,
          $todosTableFieldaccomplishedAt INTEGER,
          $todosTableFieldTodoListId INTEGER,
          FOREIGN KEY ($todosTableFieldTodoListId) REFERENCES $todoListsTableName($todoListsTableFieldId) ON DELETE CASCADE
      );
      ''');
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'tododatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: onConfigure,
      onCreate: _onCreate,
    );
  }

  /// Regarding todolistsTable -------------------------------------------------------------
  static Future<List<TodoListModel>> getAllTodoLists() async {
    Database db = await instance.database;
    List<Map> listOfTodoLists =
        await db.rawQuery('SELECT * FROM $todoListsTableName');
    if (listOfTodoLists.isEmpty) {
      Logger().d('list is empty');
    }

    List<TodoListModel> listOfTodoListModels = [];

    for (Map todoListMap in listOfTodoLists) {
      //List<TodoModel> todosOfCurrentList =
      //    await getTodosOfSpecificList(listId: todoListMap['id']);

      //The data that comes from the database is read-only data. Therefor we have to use
      //Map.of to make a copy of the data and then edit it
      //final newMap = Map.of(todoListMap);

      //finalListOfTodoLists.add(newMap);
      TodoListModel todoListModel =
          await getSpecificTodoList(id: todoListMap[todosTableFieldId]);
      listOfTodoListModels.add(todoListModel);
    }

    // finalListOfTodoLists.map((e) => TodoListModel.fromMap(e)).toList();

    return listOfTodoListModels;
  }

  static Future<int> createNewTodoList(TodoListModel todoListModel) async {
    Database db = await instance.database;
    return await db.insert(
        todoListsTableName, todoListModel.toMapForInsertNewListIntoDatabase());
  }

  static deleteAllTodoLists() async {
    Database db = await instance.database;
    return await db.delete(todoListsTableName);
  }

  static deleteSpecifiTodoList({required int id}) async {
    Database db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM $todoListsTableName WHERE $todoListsTableFieldId = ?',
        [id]);
  }

  static updateSpecificListParameters({
    required int id,
    required String listName,
    required TodoListCategory category,
  }) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE $todoListsTableName SET $todoListsTableFieldListName = ?, $todoListsTableFieldCategory = ? WHERE $todoListsTableFieldId = ?',
        [listName, category.serialize(), id]);
  }

  ///Regarding TodosTable ---------------------------------------------------------
  static Future<List<TodoModel>> getTodosOfSpecificList(
      {required int listId}) async {
    Database db = await instance.database;

    List<Map> list = await db.rawQuery(
        'SELECT * FROM $todosTableName WHERE $todosTableFieldTodoListId=?',
        ['$listId']);

    List<TodoModel> listOfTodoModels =
        list.map((e) => TodoModel.fromMap(e)).toList();
    return listOfTodoModels;
  }

  static addTodoToSpecificList(TodoModel todoModel) async {
    Database db = await instance.database;
    await db.insert(todosTableName, todoModel.toMap());
  }

  static getNameOfTodoListById({required int listId}) async {
    Database db = await instance.database;
    final nameQuery = await db.rawQuery(
        'SELECT $todoListsTableFieldListName FROM $todoListsTableName WHERE $todoListsTableFieldId=?',
        ['$listId']);
    return nameQuery.first[todoListsTableFieldListName].toString();
  }

  static getCategoryOfTodoListById({required int listId}) async {
    Database db = await instance.database;
    final categoryQuery = await db.rawQuery(
        'SELECT $todoListsTableFieldCategory FROM $todoListsTableName WHERE $todoListsTableFieldId=?',
        ['$listId']);
    int categoryInt =
        int.parse(categoryQuery.first[todoListsTableFieldCategory].toString());
    TodoListCategory category =
        TodoListCategoryExtension.deserialize(categoryInt);

    return category;
  }

  static Future<int> setAccomplishmentStatusOfTodo(
      {required int id, required bool accomplished}) async {
    Database db = await instance.database;
    int status =
        AccomplishmentStatusExtension.serialize(accomplished: accomplished);

    int? timeOfAccomplishement =
        accomplished ? DateTime.now().millisecondsSinceEpoch : null;

    final update = await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldAccomplished = ?, $todosTableFieldaccomplishedAt = ? WHERE $todosTableFieldId = ?',
        [status, timeOfAccomplishement, id]);

    return update;
  }

  static updateSpecificTodo({required TodoModel model}) async {
    Database db = await instance.database;
    final update = await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldTask = ?, $todosTableFieldRepetitionPeriod = ? WHERE $todosTableFieldId = ?',
        [model.task, model.repeatPeriod.serialize(), model.id]);

    return update;
  }

  static deleteSpecificTodo({required int id}) async {
    Database db = await instance.database;
    final delete = await db.rawDelete(
        'DELETE FROM $todosTableName WHERE $todosTableFieldId = ?', [id]);

    return delete;
  }

  static resetAllTodosOfSpecificList({required int id}) async {
    Database db = await instance.database;
    await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldAccomplished = ? WHERE $todosTableFieldTodoListId = ?',
        [AccomplishmentStatusExtension.serialize(accomplished: false), id]);
  }

  static Future<List<TodoModel>> getAllTodos() async {
    Database db = await instance.database;
    List<Map> listOfAllTodos =
        await db.rawQuery('SELECT * FROM $todosTableName');
    List<TodoModel> listOfTodoModels = [];
    for (Map map in listOfAllTodos) {
      listOfTodoModels.add(TodoModel.fromMap(map));
    }
    return listOfTodoModels;
  }

  static checkRepeatPeriodsAndResetAccomplishedIfNeccessary() async {
    final _lock = Lock();
    List<TodoModel> listOfTodoModels = await getAllTodos();
    for (TodoModel model in listOfTodoModels) {
      if (model.shouldResetAccomplishmentStatus()) {
        _lock.synchronized(() async {
          await setAccomplishmentStatusOfTodo(
              id: model.id!, accomplished: false);
        });
      }
    }
  }

  static Future<TodoListModel> getSpecificTodoList({required int id}) async {
    String listName = await getNameOfTodoListById(listId: id);
    List<TodoModel> todoModelList = await getTodosOfSpecificList(listId: id);
    TodoListCategory category = await getCategoryOfTodoListById(listId: id);

    return TodoListModel(
      id: id,
      listName: listName,
      todoModels: todoModelList,
      todoListCategory: category,
    );
  }
}
