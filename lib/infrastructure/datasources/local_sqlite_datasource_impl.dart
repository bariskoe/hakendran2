import '../../database/databse_helper.dart';
import '../../domain/entities/todolist_entity.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import 'local_sqlite_datasource.dart';

class LocalSqliteDataSourceImpl implements LocalSqliteDataSource {
  @override
  Future<int> createNewTodoList({
    required TodoListEntity todoListEntity,
  }) async {
    int idOflastCreatedRow = await DatabaseHelper.createNewTodoList(
      TodoListModel(
          todoModels: const [],
          listName: todoListEntity.listName,
          todoListCategory: todoListEntity.todoListCategory,
          uid: todoListEntity.uid),
    );

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
  Future<TodoListEntity> getSpecificTodoList({
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
  Future<int> updateSpecificTodo({
    required TodoModel todoModel,
  }) async {
    return await DatabaseHelper.updateSpecificTodo(
      model: todoModel,
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
    required TodoModel todoModel,
  }) async {
    return await DatabaseHelper.addTodoUidToSyncPendingTodos(
      todoModel: todoModel,
    );
  }

  @override
  Future<int> deleteSpecificTodo({required TodoModel todoModel}) async {
    return await DatabaseHelper.deleteSpecificTodo(todoModel: todoModel);
  }
}
