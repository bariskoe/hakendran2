import '../../domain/entities/todolist_entity.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

abstract class LocalSqliteDataSource {
  Future<int> createNewTodoList({required TodoListEntity todoListEntity});
  Future<List<TodoListModel>> getAllTodoLists();

  Future<int> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel});

  Future<int> deleteSpecifiTodoList({required int id});

  Future<bool> checkRepeatPeriodsAndResetAccomplishedIfNeccessary();

  Future<int> deleteAllTodoLists();

  Future<TodoListEntity> getSpecificTodoList({required int id});

  Future<int> addTodoToSpecificList({required TodoModel todoModel});

  Future<int> setAccomplishmentStatusOfTodo({
    required int id,
    required bool accomplished,
  });

  Future<int> updateSpecificTodo({required TodoModel todoModel});

  Future<int> resetAllTodosOfSpecificList({
    required int id,
  });
}
