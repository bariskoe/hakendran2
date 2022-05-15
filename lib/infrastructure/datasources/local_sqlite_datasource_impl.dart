import 'package:baristodolistapp/domain/entities/todolist_entity.dart';
import 'package:baristodolistapp/infrastructure/datasources/local_sqlite_datasource.dart';

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
}
