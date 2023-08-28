import 'package:baristodolistapp/models/todolist_model.dart';

abstract class ApiDatasource {
  Future<bool> synchronizeAllTodoListsWithBackend(
      List<TodoListModel> todoLists);

  Future<Map<String, dynamic>?> getAllTodoListsFromBackend();
}
