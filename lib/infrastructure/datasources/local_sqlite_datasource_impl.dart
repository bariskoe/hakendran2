import 'package:baristodolistapp/models/todo_list_update_model.dart';

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
}
