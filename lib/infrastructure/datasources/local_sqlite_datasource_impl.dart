import '../../models/todo_list_update_model.dart';

import '../../domain/entities/todolist_entity.dart';
import 'local_sqlite_datasource.dart';

import '../../database/databse_helper.dart';
import '../../models/todolist_model.dart';

class LocalSqliteDataSourceImpl implements LocalSqliteDataSource {
  @override
  Future<int> createNewTodoList({
    required TodoListEntity todoListEntity,
  }) async {
    int idOflastCreatedRow = await DatabaseHelper.createNewTodoList(
      TodoListModel(
        id: null,
        todoModels: const [],
        listName: todoListEntity.listName,
        todoListCategory: todoListEntity.todoListCategory,
      ),
    );
    return idOflastCreatedRow;
  }

  @override
  Future<List<TodoListModel>> getAllTodoLists() async {
    return await DatabaseHelper.getAllTodoLists();
  }

  @override
  Future<int> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel}) async {
    return await DatabaseHelper.updateSpecificListParameters(
        todoListUpdateModel: todoListUpdateModel);
  }

  @override
  Future<int> deleteSpecifiTodoList({required int id}) async {
    return await DatabaseHelper.deleteSpecifiTodoList(id: id);
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
  Future<TodoListEntity> getSpecificTodoList({required int id}) async {
    return await DatabaseHelper.getSpecificTodoList(id: id);
  }
}
