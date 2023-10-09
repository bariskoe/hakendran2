import '../../domain/entities/todolist_entity.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

abstract class LocalSqliteDataSource {
  Future<int> createNewTodoList({required TodoListEntity todoListEntity});
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

  Future<int> updateSpecificTodo({required TodoModel todoModel});

  Future<int> deleteSpecificTodo({required TodoModel todoModel});

  Future<int> resetAllTodosOfSpecificList({
    required String uid,
  });
  Future<int> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  });
  Future<int> addTodoUidToSyncPendingTodos({
    required TodoModel todoModel,
  });
}
