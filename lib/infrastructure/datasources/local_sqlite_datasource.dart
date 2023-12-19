import 'package:baristodolistapp/domain/parameters/todo_parameters.dart';

import '../../domain/entities/todolist_entity.dart';
import '../../domain/parameters/sync_pending_photo_params.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todo_model.dart';
import '../../models/todo_update_model.dart';
import '../../models/todolist_model.dart';

abstract class LocalSqliteDataSource {
  Future<int> createNewTodoList({
    required TodoListModel todoListModel,
  });

  Future<List<TodoListModel>> getAllTodoLists();

  Future<int> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel});

  Future<int> deleteSpecifiTodoList({required String uid});

  Future<bool> checkRepeatPeriodsAndResetAccomplishedIfNeccessary();

  Future<int> deleteAllTodoLists();

  Future<TodoListEntity?> getSpecificTodoList({required String uid});

  Future<int> addTodoToSpecificList({required TodoModel todoModel});

  Future<int> setAccomplishmentStatusOfTodo({
    required String uid,
    required bool accomplished,
  });

  Future<int> updateSpecificTodoNew({required TodoUpdateModel todoUpdateModel});

  Future<int> deleteSpecificTodo({required TodoParameters todoParameters});

  Future<int> deleteFromsyncPendingPhotos({required String imageName});

  Future<int> resetAllTodosOfSpecificList({
    required String uid,
  });
  Future<int> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  });
  Future<int> addTodoUidToSyncPendingTodos({
    required TodoParameters todoParameters,
  });

  Future<int> addToSyncPendingPhotos({
    required SyncPendingPhotoParams syncPendingPhotoParams,
  });
}
