import 'package:baristodolistapp/models/downloadable_photos_model.dart';
import 'package:baristodolistapp/models/firestore_data_info_model.dart';

import '../../models/api_action_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

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
  Future<FirestoreDataInfoModel?> getDataInfo();

  /// Loops through the table [syncPendingTodoLists], takes every uid and uploads
  /// the respective Todolist to the cloud
  Future<bool> syncPendingTodoLists();

  /// Loops through the table [syncPendingTodos], takes every uid and uploads
  /// the respective Todo to the cloud
  Future<bool> syncPendingTodos();

  /// Loops through the table [syncPendingPhotos] and uploads / downloads / deletes
  /// every Photo to / from / in the cloud storage
  Future<bool> syncPendingPhotos();

  /// This method executes an api action that comes from the backend (HATEOAS). It is designed
  /// to make an app scalable
  Future<bool> performApiAction({
    required ApiActionModel apiActionModel,
  });

  /// Gets a list of download urls of the photos that are stored in Firebase Storage.
  Future<PhotoDownloadUrlsModel?> getPhotoDownloadUrls();
}
