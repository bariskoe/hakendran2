import 'package:logger/logger.dart';

import '../../database/databse_helper.dart';
import '../../domain/entities/todolist_entity.dart';
import '../../domain/parameters/sync_pending_photo_params.dart';
import '../../domain/parameters/todo_parameters.dart';
import '../../models/sync_pending_photo_model.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todo_model.dart';
import '../../models/todo_update_model.dart';
import '../../models/todolist_model.dart';
import 'local_sqlite_datasource.dart';

class LocalSqliteDataSourceImpl implements LocalSqliteDataSource {
  @override
  Future<int> createNewTodoList({
    required TodoListModel todoListModel,
  }) async {
    int idOflastCreatedRow =
        await DatabaseHelper.createNewTodoList(todoListModel);

    return idOflastCreatedRow;
  }

  @override
  Future<List<TodoListModel>> getAllTodoLists() async {
    return await DatabaseHelper.getAllTodoLists();
  }

  @override
  Future<int> updateSpecificListParameters({
    required TodoListUpdateModel todoListUpdateModel,
  }) async {
    return await DatabaseHelper.updateSpecificListParameters(
      todoListUpdateModel: todoListUpdateModel,
    );
  }

  @override
  Future<int> deleteSpecifiTodoList({
    required String uid,
  }) async {
    return await DatabaseHelper.deleteSpecificTodoList(
      uid: uid,
    );
  }

  @override
  Future<bool> checkRepeatPeriodsAndResetAccomplishedIfNeccessary() async {
    return await DatabaseHelper
        .checkRepeatPeriodsAndResetAccomplishedIfNeccessary();
  }

  @override
  Future<int> deleteAllTodoLists() async {
    return await DatabaseHelper.deleteAllTodoLists();
  }

  @override
  Future<TodoListEntity?> getSpecificTodoList({
    required String uid,
  }) async {
    return await DatabaseHelper.getSpecificTodoList(
      uid: uid,
    );
  }

  @override
  Future<int> addTodoToSpecificList({
    required TodoModel todoModel,
  }) async {
    return await DatabaseHelper.addTodoToSpecificList(
      todoModel: todoModel,
    );
  }

  @override
  Future<int> setAccomplishmentStatusOfTodo({
    required String uid,
    required bool accomplished,
  }) async {
    return await DatabaseHelper.setAccomplishmentStatusOfTodo(
      uid: uid,
      accomplished: accomplished,
    );
  }

  @override
  Future<int> resetAllTodosOfSpecificList({
    required String uid,
  }) async {
    return await DatabaseHelper.resetAllTodosOfSpecificList(
      uid: uid,
    );
  }

  @override
  Future<int> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  }) async {
    return await DatabaseHelper.addTodoListUidToSyncPendingTodoLists(
      uid: uid,
    );
  }

  @override
  Future<int> addTodoUidToSyncPendingTodos({
    required TodoParameters todoParameters,
  }) async {
    return await DatabaseHelper.addTodoUidToSyncPendingTodos(
      todoParameters: todoParameters,
    );
  }

  @override
  Future<int> deleteSpecificTodo(
      {required TodoParameters todoParameters}) async {
    return await DatabaseHelper.deleteSpecificTodo(
        todoParameters: todoParameters);
  }

  @override
  Future<int> addToSyncPendingPhotos(
      {required SyncPendingPhotoParams syncPendingPhotoParams}) async {
    Logger()
        .d('adding to syncpendingphotos ${syncPendingPhotoParams.photoName}');
    final model =
        SyncPendingPhotoModel.fromParams(params: syncPendingPhotoParams);
    return await DatabaseHelper.addToSyncPendingPhotos(model: model);
  }

  @override
  Future<int> updateSpecificTodoNew(
      {required TodoUpdateModel todoUpdateModel}) async {
    return await DatabaseHelper.updateSpecificTodoNew(
        todoUpdateModel: todoUpdateModel);
  }

  @override
  Future<int> deleteFromsyncPendingPhotos({required String imageName}) async {
    return await DatabaseHelper.deleteFromsyncPendingPhotos(
        relativePath: imageName);
  }
}
