import 'package:baristodolistapp/models/api_action_model.dart';
import 'package:baristodolistapp/models/todo_model.dart';
import 'package:baristodolistapp/models/todolist_model.dart';

abstract class ApiDatasource {
  // Future<bool> synchronizeAllTodoListsWithBackend(
  //     List<TodoListModel> todoLists);

  Future<bool> createTodoList({
    required TodoListModel todoListModel,
  });

  Future addTodoToSpecificList({required TodoModel todoModel});

  // Makes an Api request to delete a specific Todo from a specific TodoList
  Future deleteTodoFromSpecificList({required Map<String, dynamic> map});

  /// Makes an Api request to delete a specific TodoList
  Future deleteTodoList({required String uid});

  Future<Map<String, dynamic>?> getAllTodoListsFromBackend();

  // Gets relevant information from Backend about the saved Todolists like timeStamp and listLength
  // Returns null if an error occurs or if there is no internet connection.
  //! This is dangerous. It should not return null if there is no internet connection because having no data and having no internet is not the same thing
  Future<Map<String, dynamic>?> getDataInfo();

  /// Loops through the table [syncPendingTodoLists], takes every uid and uploads
  /// the respective Todolist to the cloud
  Future<bool> syncPendingTodoLists();

  /// Loops through the table [syncPendingTodos], takes every uid and uploads
  /// the respective Todo to the cloud
  Future<bool> syncPendingTodos();

  /// This method executes an api action that comes from the backend. It is designed
  /// to make an app scalable
  Future<bool> performApiAction({
    required ApiActionModel apiActionModel,
  });
}
