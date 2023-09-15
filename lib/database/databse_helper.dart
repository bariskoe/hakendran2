import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import '../dependency_injection.dart';
import '../models/todo_list_update_model.dart';
import '../models/todo_model.dart';
import '../models/todolist_model.dart';
import '../strings/string_constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  ///Fields of the TodoListsTable ----------------------------------------------
  static const String todoListsTableName = 'todoliststable';
  static const String todoListsTableFieldId = 'id';
  static const String todoListsTableFieldUuId = 'uuid';
  static const String todoListsTableFieldListName =
      'listName'; //i.E. Workout exercises
  static const String todoListsTableFieldCategory =
      'category'; //i.E. 'Work' or 'Nutrition'

  ///Fields of the TodosTable --------------------------------------------------
  static const String todosTableName = 'todostable';
  static const String todosTableFieldId = 'id';
  static const String todosTableFieldTodoUuId = 'uuid';
  static const String todosTableFieldTask = 'task'; //i.E. '100 Situps'
  static const String todosTableFieldAccomplished = 'accomplished';
  static const String todosTableFieldRepetitionPeriod = 'repetitionperiod';
  static const String todosTableFieldTodoListId =
      'todolistid'; //!Will be unneccessary if todolistuuid exists
  static const String todosTableFieldTodoListUuId =
      'todolistUuid'; //Foreign key
  static const String todosTableFieldaccomplishedAt = 'accomplishedAt';

  ///Other TodolistModel variables ---------------------------------------------
  static const String numberOfTodos = 'numberOfTodos';
  static const String numberOfAccomplishedTodos = 'numberOfAccomplishedTodos';
  static const String todos = 'todos';

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    // An integer primary key might be unnecessary if we have a uuid
    await db.execute('''
      CREATE TABLE $todoListsTableName(
          $todoListsTableFieldId INTEGER,
          $todoListsTableFieldUuId TEXT PRIMARY KEY,
          $todoListsTableFieldListName TEXT,
          $todoListsTableFieldCategory INTEGER
      );
      ''');

    await db.execute('''
      CREATE TABLE $todosTableName(
          $todosTableFieldId INTEGER PRIMARY KEY AUTOINCREMENT,
          $todosTableFieldTodoUuId TEXT,
          $todosTableFieldTask TEXT,
          $todosTableFieldAccomplished INTEGER,
          $todosTableFieldRepetitionPeriod INTEGER,
          $todosTableFieldaccomplishedAt INTEGER,
          $todosTableFieldTodoListId INTEGER,
          $todosTableFieldTodoListUuId TEXT,
          FOREIGN KEY ($todosTableFieldTodoListUuId) REFERENCES $todoListsTableName($todoListsTableFieldUuId) ON DELETE CASCADE
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
          await getSpecificTodoList(uuid: todoListMap[todoListsTableFieldUuId]);
      listOfTodoListModels.add(todoListModel);
    }

    // finalListOfTodoLists.map((e) => TodoListModel.fromMap(e)).toList();

    return listOfTodoListModels;
  }

  static Future<int> createNewTodoList(
    TodoListModel todoListModel,
  ) async {
    Database db = await instance.database;
    saveTimestamp();
    final mapToInsert = todoListModel.toMapForInsertNewListIntoDatabase();
    Logger().d('Todolist being saved in localdatabase: $mapToInsert');
    return await db.insert(todoListsTableName, mapToInsert);
  }

  static Future<int> deleteAllTodoLists() async {
    Database db = await instance.database;

    saveTimestamp();
    return await db.delete(todoListsTableName);
  }

  static Future<int> deleteSpecificTodoList({
    required String uuid,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.rawDelete(
        'DELETE FROM $todoListsTableName WHERE $todoListsTableFieldUuId = ?',
        [uuid]);
  }

  static Future<int> updateSpecificListParameters({
    required TodoListUpdateModel todoListUpdateModel,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.rawUpdate(
        'UPDATE $todoListsTableName SET $todoListsTableFieldListName = ?, $todoListsTableFieldCategory = ? WHERE $todoListsTableFieldUuId = ?',
        [
          todoListUpdateModel.listName,
          todoListUpdateModel.todoListCategory.serialize(),
          todoListUpdateModel.uuid
        ]);
  }

  ///Regarding TodosTable ---------------------------------------------------------
  static Future<List<TodoModel>> getTodosOfSpecificList({
    required String listUuId,
  }) async {
    Database db = await instance.database;

    List<Map> list = await db.rawQuery(
        'SELECT * FROM $todosTableName WHERE $todosTableFieldTodoListUuId=?',
        [listUuId]);

    List<TodoModel> listOfTodoModels =
        list.map((e) => TodoModel.fromMap(e)).toList();
    return listOfTodoModels;
  }

  static addTodoToSpecificList({
    required TodoModel todoModel,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.insert(todosTableName, todoModel.toMap());
  }

  static getNameOfTodoListById({
    required String listUuId,
  }) async {
    Database db = await instance.database;
    final nameQuery = await db.rawQuery(
        'SELECT $todoListsTableFieldListName FROM $todoListsTableName WHERE $todoListsTableFieldUuId=?',
        [listUuId]);
    return nameQuery.first[todoListsTableFieldListName].toString();
  }

  static Future<TodoListCategory> getCategoryOfTodoListById(
      {required String listUuId}) async {
    Database db = await instance.database;
    final categoryQuery = await db.rawQuery(
        'SELECT $todoListsTableFieldCategory FROM $todoListsTableName WHERE $todoListsTableFieldUuId=?',
        [listUuId]);
    int categoryInt =
        int.parse(categoryQuery.first[todoListsTableFieldCategory].toString());
    TodoListCategory category =
        TodoListCategoryExtension.deserialize(categoryInt);

    return category;
  }

  static Future<int> setAccomplishmentStatusOfTodo(
      {required String uuid, required bool accomplished}) async {
    Database db = await instance.database;
    int status =
        AccomplishmentStatusExtension.serialize(accomplished: accomplished);

    int? timeOfAccomplishement =
        accomplished ? DateTime.now().millisecondsSinceEpoch : null;

    final update = await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldAccomplished = ?, $todosTableFieldaccomplishedAt = ? WHERE $todosTableFieldTodoUuId = ?',
        [status, timeOfAccomplishement, uuid]);
    saveTimestamp();
    return update;
  }

  static Future<int> updateSpecificTodo({
    required TodoModel model,
  }) async {
    Database db = await instance.database;
    final update = await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldTask = ?, $todosTableFieldRepetitionPeriod = ? WHERE $todosTableFieldId = ?',
        [model.task, model.repeatPeriod?.serialize(), model.id]);
    saveTimestamp();
    return update;
  }

  static Future<int> deleteSpecificTodo({
    required String uuid,
  }) async {
    Database db = await instance.database;
    final delete = await db.rawDelete(
        'DELETE FROM $todosTableName WHERE $todosTableFieldTodoUuId = ?',
        [uuid]);
    saveTimestamp();
    return delete;
  }

  static Future<int> resetAllTodosOfSpecificList({
    required String uuid,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldAccomplished = ? WHERE $todosTableFieldTodoListUuId = ?',
        [AccomplishmentStatusExtension.serialize(accomplished: false), uuid]);
  }

  // Just for debugging puposes
  static Future<List<TodoModel>> getAllTodos() async {
    Database db = await instance.database;
    List<Map> listOfAllTodos =
        await db.rawQuery('SELECT * FROM $todosTableName');
    List<TodoModel> listOfTodoModels = [];
    for (Map map in listOfAllTodos) {
      listOfTodoModels.add(TodoModel.fromMap(map));
    }
    Logger().d('All todos: $listOfTodoModels');
    return listOfTodoModels;
  }

  static Future<bool>
      checkRepeatPeriodsAndResetAccomplishedIfNeccessary() async {
    final lock = Lock();
    List<TodoModel> listOfTodoModels = await getAllTodos();
    for (TodoModel model in listOfTodoModels) {
      if (model.shouldResetAccomplishmentStatus()) {
        lock.synchronized(() async {
          await setAccomplishmentStatusOfTodo(
              uuid: model.uuid!, accomplished: false);
        });
      }
    }
    return true;
  }

  static Future<TodoListModel> getSpecificTodoList({
    required String uuid,
  }) async {
    String listName = await getNameOfTodoListById(listUuId: uuid);
    List<TodoModel> todoModelList =
        await getTodosOfSpecificList(listUuId: uuid);
    TodoListCategory category = await getCategoryOfTodoListById(listUuId: uuid);

    return TodoListModel(
      uuid: uuid,
      listName: listName,
      todoModels: todoModelList,
      todoListCategory: category,
    );
  }
}

Future<bool> saveTimestamp() async {
  final now = DateTime.now().millisecondsSinceEpoch;
  return await getIt<SharedPreferences>()
      .setInt(StringConstants.spDBTimestamp, now);
}

Future<int?> getTimestampOfLastDBTransaction() async {
  return getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
}
