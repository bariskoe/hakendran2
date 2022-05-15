import '../../domain/entities/todolist_entity.dart';

abstract class LocalSqliteDataSource {
  Future<int> createNewTodoList({required TodoListEntity todoListEntity});
}
