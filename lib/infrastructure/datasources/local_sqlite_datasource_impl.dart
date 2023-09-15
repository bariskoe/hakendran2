import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource_impl.dart';
import 'package:baristodolistapp/models/todo_model.dart';

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
          uuid: todoListEntity.uuid),
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
    required String uuid,
  }) async {
    return await DatabaseHelper.deleteSpecificTodoList(
      uuid: uuid,
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
    required String uuid,
  }) async {
    return await DatabaseHelper.getSpecificTodoList(
      uuid: uuid,
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
    required String uuid,
    required bool accomplished,
  }) async {
    return await DatabaseHelper.setAccomplishmentStatusOfTodo(
      uuid: uuid,
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
    required String uuid,
  }) async {
    return await DatabaseHelper.resetAllTodosOfSpecificList(
      uuid: uuid,
    );
  }
}
