import 'dart:async';
import 'dart:io';

import 'package:baristodolistapp/services/path_builder.dart';

import '../domain/parameters/todo_parameters.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import '../dependency_injection.dart';
import '../models/sync_pending_photo_model.dart';
import '../models/todo_list_update_model.dart';
import '../models/todo_model.dart';
import '../models/todo_update_model.dart';
import '../models/todolist_model.dart';
import '../strings/string_constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  /// Set [_database] to null when logging out in order to trigger a new
  /// Database initialization with a new path with the new user id
  static onLogout() {
    _database = null;
  }

  Future<Database> get database async => _database ??= await _initDatabase();

  ///Fields of the TodoListsTable ----------------------------------------------
  static const String todoListsTableName = 'todoliststable';

  static const String todoListsTableFieldUid = 'uid';
  static const String todoListsTableFieldListName =
      'listName'; //i.E. Workout exercises
  static const String todoListsTableFieldCategory =
      'category'; //i.E. 'Work' or 'Nutrition'

  ///Fields of the TodosTable --------------------------------------------------
  static const String todosTableName = 'todostable';

  static const String todosTableFieldTodoUid = 'uid';
  static const String todosTableFieldTask = 'task'; //i.E. '100 Situps'
  static const String todosTableFieldAccomplished = 'accomplished';
  static const String todosTableFieldRepetitionPeriod = 'repetitionperiod';

  static const String todosTableFieldTodoListUid = 'todolistUid'; //Foreign key
  static const String todosTableFieldaccomplishedAt = 'accomplishedAt';
  static const String todosTableFieldImagePath = 'imagePath';
  static const String todosTableFieldDownloadUrl = 'downloadUrl';

  ///Other TodolistModel variables ---------------------------------------------
  static const String numberOfTodos = 'numberOfTodos';
  static const String numberOfAccomplishedTodos = 'numberOfAccomplishedTodos';
  static const String todos = 'todos';

  ///---------------------------------------------------------------------------
  static const String syncPendigTodolistsName = 'syncPendigTodolists';

  /// Fields of the syncPendigTodolists list.

  /// This uid represents the uid of a TodoList that has not been synched with the
  /// backend yet.
  static const String syncPendigTodolistsFieldUid = 'uid';

  ///---------------------------------------------------------------------------
  static const String syncPendigTodosName = 'syncPendigTodos';

  /// Fields of the syncPendigTodos list.
  /// This uid represents the uid of a Todo that has not been synched with the
  /// backend yet.
  static const syncPendigTodosFieldUid = 'uid';

  /// This is the uid of the TodoList which the todo belongs to.
  static const syncPendigTodosFieldParentTodoListUid = 'parentTodoListUid';

  /// Fields of the syncPendingPhotos-------------------------------------------
  static const String syncPendingPhotosName = 'syncPendingPhotos';
  static const String syncPendingPhotosFieldRelativePath = 'relativePath';
  static const String syncPendingPhotosFieldMethod = 'method';
  static const String syncPendingPhotosFieldDownloadUrl = 'downloadUrl';

  ///---------------------------------------------------------------------------
  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $todoListsTableName(
         
          $todoListsTableFieldUid TEXT PRIMARY KEY,
          $todoListsTableFieldListName TEXT,
          $todoListsTableFieldCategory INTEGER
      );
      ''');

    await db.execute('''
      CREATE TABLE $todosTableName(
          $todosTableFieldTodoUid TEXT PRIMARY KEY,
          $todosTableFieldTask TEXT,
          $todosTableFieldAccomplished INTEGER,
          $todosTableFieldRepetitionPeriod INTEGER,
          $todosTableFieldaccomplishedAt INTEGER,
          $todosTableFieldImagePath TEXT,
          $todosTableFieldDownloadUrl TEXT,
          $todosTableFieldTodoListUid TEXT,
          FOREIGN KEY ($todosTableFieldTodoListUid) REFERENCES $todoListsTableName($todoListsTableFieldUid) ON DELETE CASCADE
      );
      ''');

    await db.execute('''
      CREATE TABLE $syncPendigTodolistsName (
          $syncPendigTodolistsFieldUid TEXT
      );
      ''');

    await db.execute('''
      CREATE TABLE $syncPendigTodosName (
          $syncPendigTodosFieldParentTodoListUid TEXT,
          $syncPendigTodosFieldUid TEXT
          
      );
      ''');

    await db.execute('''
      CREATE TABLE $syncPendingPhotosName (
          $syncPendingPhotosFieldRelativePath TEXT,
          $syncPendingPhotosFieldMethod TEXT,
          $syncPendingPhotosFieldDownloadUrl TEXT
          
      );
      ''');
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final userId = getIt<SharedPreferences>()
        .getString(StringConstants.spFirebaseUserIDKey);

    String path = join(documentsDirectory.path, userId, 'tododatabase.db');
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
      TodoListModel? todoListModel =
          await getSpecificTodoList(uid: todoListMap[todoListsTableFieldUid]);
      listOfTodoListModels.add(todoListModel!);
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
    int insertedRow = await db.insert(todoListsTableName, mapToInsert);

    return insertedRow;
  }

  static Future<int> deleteAllTodoLists() async {
    Database db = await instance.database;

    saveTimestamp();
    return await db.delete(todoListsTableName);
  }

  static Future<int> deleteSpecificTodoList({
    required String uid,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.rawDelete(
        'DELETE FROM $todoListsTableName WHERE $todoListsTableFieldUid = ?',
        [uid]);
  }

  static Future<int> updateSpecificListParameters({
    required TodoListUpdateModel todoListUpdateModel,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.rawUpdate(
        'UPDATE $todoListsTableName SET $todoListsTableFieldListName = ?, $todoListsTableFieldCategory = ? WHERE $todoListsTableFieldUid = ?',
        [
          todoListUpdateModel.listName,
          todoListUpdateModel.todoListCategory.serialize(),
          todoListUpdateModel.uid
        ]);
  }

  ///Regarding TodosTable ---------------------------------------------------------
  static Future<List<TodoModel>> getTodosOfSpecificList({
    required String listUid,
  }) async {
    Database db = await instance.database;

    List<Map> list = await db.rawQuery(
        'SELECT * FROM $todosTableName WHERE $todosTableFieldTodoListUid=?',
        [listUid]);

    List<TodoModel> listOfTodoModels =
        list.map((e) => TodoModel.fromMap(e)).toList();
    return listOfTodoModels;
  }

  static addTodoToSpecificList({
    required TodoModel todoModel,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    int insertedRow = await db.insert(todosTableName, todoModel.toMap());
    return insertedRow;
  }

  static getNameOfTodoListById({
    required String listUid,
  }) async {
    Database db = await instance.database;
    final nameQuery = await db.rawQuery(
        'SELECT $todoListsTableFieldListName FROM $todoListsTableName WHERE $todoListsTableFieldUid=?',
        [listUid]);
    return nameQuery.first[todoListsTableFieldListName].toString();
  }

  static Future<TodoListCategory> getCategoryOfTodoListById(
      {required String listUid}) async {
    Database db = await instance.database;
    final categoryQuery = await db.rawQuery(
        'SELECT $todoListsTableFieldCategory FROM $todoListsTableName WHERE $todoListsTableFieldUid=?',
        [listUid]);
    int categoryInt =
        int.parse(categoryQuery.first[todoListsTableFieldCategory].toString());
    TodoListCategory category =
        TodoListCategoryExtension.deserialize(categoryInt);

    return category;
  }

  static Future<int> setAccomplishmentStatusOfTodo(
      {required String uid, required bool accomplished}) async {
    Database db = await instance.database;
    int status =
        AccomplishmentStatusExtension.serialize(accomplished: accomplished);

    int? timeOfAccomplishement =
        accomplished ? DateTime.now().millisecondsSinceEpoch : null;

    final update = await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldAccomplished = ?, $todosTableFieldaccomplishedAt = ? WHERE $todosTableFieldTodoUid = ?',
        [status, timeOfAccomplishement, uid]);
    saveTimestamp();
    return update;
  }

  static Future<int> updateSpecificTodoNew(
      {required TodoUpdateModel todoUpdateModel}) async {
    Database db = await instance.database;
    List<String> fieldsToUpdate = [];
    List args = [];

    if (todoUpdateModel.task != null) {
      fieldsToUpdate.add(todosTableFieldTask);
      args.add(todoUpdateModel.task);
    }
    if (todoUpdateModel.repeatPeriod != null) {
      fieldsToUpdate.add(todosTableFieldRepetitionPeriod);
      args.add(todoUpdateModel.repeatPeriod?.serialize());
    }
    if (todoUpdateModel.imagePath != null) {
      fieldsToUpdate.add(todosTableFieldImagePath);
      args.add(todoUpdateModel.imagePath);
    }
    if (todoUpdateModel.accomplishedAt != null) {
      fieldsToUpdate.add(todosTableFieldaccomplishedAt);
      args.add(todoUpdateModel.accomplishedAt?.millisecondsSinceEpoch);
    }
    if (todoUpdateModel.downloadUrl != null) {
      fieldsToUpdate.add(todosTableFieldDownloadUrl);
      args.add(todoUpdateModel.downloadUrl);
    }
    if (todoUpdateModel.parentTodoListId != null) {
      fieldsToUpdate.add(todosTableFieldTodoListUid);
      args.add(todoUpdateModel.parentTodoListId);
    }
    if (todoUpdateModel.accomplished != null) {
      fieldsToUpdate.add(todosTableFieldAccomplished);
      args.add(todoUpdateModel.accomplished);
    }
    if (todoUpdateModel.deleteImage) {
      fieldsToUpdate.add(todosTableFieldImagePath);
      args.add(null);
      fieldsToUpdate.add(todosTableFieldDownloadUrl);
      args.add(null);
    }
    args.add(todoUpdateModel.uid);
    String fieldsToUpdateString = '';
    if (fieldsToUpdate.isEmpty) {
      Logger().d('No fields to update');
      return 0;
    }
    if (fieldsToUpdate.length == 1) {
      fieldsToUpdateString = '${fieldsToUpdate.first} = ?';
    } else {
      fieldsToUpdateString = '${fieldsToUpdate.join(' = ?, ')} = ?';
    }
    String sqliteUpdateStatement =
        'UPDATE $todosTableName SET $fieldsToUpdateString WHERE $todosTableFieldTodoUid = ?';
    final update = await db.rawUpdate(sqliteUpdateStatement, args);
    saveTimestamp();

    return update;
  }

  static Future<int> deleteSpecificTodo({
    required TodoParameters todoParameters,
  }) async {
    Database db = await instance.database;
    final delete = await db.rawDelete(
        'DELETE FROM $todosTableName WHERE $todosTableFieldTodoUid = ?',
        [todoParameters.uid]);
    saveTimestamp();
    return delete;
  }

  static Future<int> resetAllTodosOfSpecificList({
    required String uid,
  }) async {
    Database db = await instance.database;
    saveTimestamp();
    return await db.rawUpdate(
        'UPDATE $todosTableName SET $todosTableFieldAccomplished = ? WHERE $todosTableFieldTodoListUid = ?',
        [AccomplishmentStatusExtension.serialize(accomplished: false), uid]);
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
              uid: model.uid, accomplished: false);
        });
      }
    }
    return true;
  }

  static Future<TodoModel?> getSpecificTodo({
    required String uid,
  }) async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM $todosTableName WHERE $todosTableFieldTodoUid=?', [uid]);
    if (list.isNotEmpty) {
      return TodoModel.fromMap(list.first);
    } else {
      return null;
    }
  }

  static Future<TodoListModel?> getSpecificTodoList({
    required String uid,
  }) async {
    try {
      String listName = await getNameOfTodoListById(listUid: uid);
      List<TodoModel> todoModelList =
          await getTodosOfSpecificList(listUid: uid);
      TodoListCategory category = await getCategoryOfTodoListById(listUid: uid);

      return TodoListModel(
        uid: uid,
        listName: listName,
        todoModels: todoModelList,
        todoListCategory: category,
      );
    } catch (e) {
      Logger().e(
          "Error getting Todolist from database: $e , this is normal after a delete operation.");

      return null;
    }
  }

  /// Regarding syncPendigTodolists table --------------------------------------
  static Future<int> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  }) async {
    Database db = await instance.database;

    final mapToInsert = {syncPendigTodolistsFieldUid: uid};
    Logger().d('TodolistUid being saved in syncPendigTodolists: $mapToInsert');
    return await db.insert(syncPendigTodolistsName, mapToInsert);
  }

  static Future<int> deleteFromsyncPendigTodolists(
      {required String uid}) async {
    Database db = await instance.database;

    return await db.rawDelete(
        'DELETE FROM $syncPendigTodolistsName WHERE $syncPendigTodolistsFieldUid = ?',
        [uid]);
  }

  static Future<Map<String, dynamic>>
      getAllEntriesOfsyncPendigTodolists() async {
    Database db = await instance.database;

    List<Map> list =
        await db.rawQuery('SELECT * FROM $syncPendigTodolistsName');
    final mapToReturn = {
      'syncPendigTodoLists': list.isNotEmpty ? list : [],
      'numberOfEntries': list.isNotEmpty ? list.length : 0
    };
    Logger().d('TodolistUids in syncPendigTodolists: $list');
    return mapToReturn;
  }

  /// Regarding syncPendigTodos table ------------------------------------------
  static Future<int> addTodoUidToSyncPendingTodos({
    required TodoParameters todoParameters,
  }) async {
    Database db = await instance.database;

    final mapToInsert = {
      syncPendigTodosFieldUid: todoParameters.uid,
      syncPendigTodosFieldParentTodoListUid: todoParameters.parentTodoListId
    };
    try {
      final success = await db.insert(syncPendigTodosName, mapToInsert);

      return success;
    } catch (e) {
      Logger().e('Error in addTodoUidToSyncPendingTodos: $e');
      return 0;
    }
  }

  static Future<int> deleteFromsyncPendigTodos({required String uid}) async {
    Database db = await instance.database;

    return await db.rawDelete(
        'DELETE FROM $syncPendigTodosName WHERE $syncPendigTodosFieldUid = ?',
        [uid]);
  }

  static Future<Map<String, dynamic>> getAllEntriesOfsyncPendigTodos() async {
    Database db = await instance.database;

    List<Map> list = await db.rawQuery('SELECT * FROM $syncPendigTodosName');
    Logger().d('TodoUids  saved in syncPendigTodos: $list');
    final mapToReturn = {
      'syncPendigTodos': list.isNotEmpty ? list : [],
      'numberOfEntries': list.isNotEmpty ? list.length : 0
    };
    return mapToReturn;
  }

  /// Regarding SyncPendingPhotos ------------------------------------------------
  static Future<int> addToSyncPendingPhotos({
    required SyncPendingPhotoModel model,
  }) async {
    Database db = await instance.database;

    final mapToInsert = model.toMap();
    Logger().d('Map being saved in syncPendigPhotos: $mapToInsert');
    return await db.insert(syncPendingPhotosName, mapToInsert);
  }

  static Future<int> deleteFromsyncPendingPhotos(
      {required String relativePath}) async {
    Database db = await instance.database;
    Logger().d('Deleting $relativePath from syncPendingPhotos');
    return await db.rawDelete(
        'DELETE FROM $syncPendingPhotosName WHERE $syncPendingPhotosFieldRelativePath = ?',
        [relativePath]);
  }

  static Future<List<Map<String, Object?>>>
      getAllEntriesFromSyncPendingPhotos() async {
    Database db = await instance.database;
    List<Map<String, Object?>> entries =
        await db.rawQuery('SELECT * FROM $syncPendingPhotosName');

    return entries;
  }

  /// Other helper functions ----------------------------------------------------
  static Future<bool> hasEntries(String tableName) async {
    Database db = await instance.database;
    try {
      final list = await db.rawQuery('SELECT * FROM $tableName LIMIT 1');
      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
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
