import 'package:baristodolistapp/models/todo_model.dart';
import 'package:baristodolistapp/models/todolist_model.dart';

abstract class ApiDatasource {
  Future<bool> synchronizeAllTodoListsWithBackend(
      List<TodoListModel> todoLists);

  Future<bool> createTodoList({
    required TodoListModel todoListModel,
  });

  Future addTodoToSpecificList({required TodoModel todoModel});

  Future<Map<String, dynamic>?> getAllTodoListsFromBackend();

  // Gets relevant information from Backend about the saved Todolists like timeStamp and listLength
  // Returns null if an error occurs or if there is no internet connection.
  //! This is dangerous. It should not return null if there is no internet connection because having no data and having no internet is not the same thing
  Future<Map<String, dynamic>?> getDataInfo();

  /// Loops through the table [syncPendingTodoLists], takes every uid and uploads
  /// the respective Todolist to the cloud
  Future<bool> uploadSyncPendingTodoLists();
}
