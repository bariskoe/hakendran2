import '../../models/todolist_model.dart';

import '../../domain/entities/todolist_entity.dart';
import '../../models/todo_list_update_model.dart';

abstract class LocalSqliteDataSource {
  Future<int> createNewTodoList({required TodoListEntity todoListEntity});
  Future<List<TodoListModel>> getAllTodoLists();

  Future<int> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel});

  Future<int> deleteSpecifiTodoList({required int id});

  Future<bool> checkRepeatPeriodsAndResetAccomplishedIfNeccessary();

  Future<int> deleteAllTodoLists();
}
