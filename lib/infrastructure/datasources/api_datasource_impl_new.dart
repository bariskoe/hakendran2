import 'package:baristodolistapp/models/api_action_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/databse_helper.dart';
import '../../dependency_injection.dart';
import '../../domain/errors/errors.dart';
import '../../models/firestore_data_info_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../../services/connectivity_service.dart';
import '../../strings/string_constants.dart';
import 'api_datasource.dart';

class ApiDataSourceImplNew implements ApiDatasource {
  final baseUrl =
      'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction';

  final dataInfoEndpoint = 'getdatainfo';

  final todolists = 'todolists';
  final todos = 'todos';

  String buildUrlString(List<String> paths) {
    String url = baseUrl;
    for (String path in paths) {
      url = url + '/$path';
    }
    return url;
  }

  final dio = Dio(); // With default `Options`.

  // void configureDio() {
  //   final options = BaseOptions(
  //     baseUrl: 'https://api.pub.dev',
  //     connectTimeout: const Duration(seconds: 5),
  //     receiveTimeout: const Duration(seconds: 3),
  //   );
  //   dio.options = options;
  // }

// Future<Response<T>> request<T>(
//   String path, {
//   Object? data,
//   Map<String, dynamic>? queryParameters,
//   CancelToken? cancelToken,
//   Options? options,
//   ProgressCallback? onSendProgress,
//   ProgressCallback? onReceiveProgress,
// });

  Future<Response> makeRequest({
    required List<String> pathParts,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    bool? isConnected = await getIt<ConnectivityService>().getConnectivity;
    Logger().d('isConnected in makeRequest is $isConnected');

    if (isConnected == null || isConnected == false) {
      throw NotConnectedToTheInternetError();
    }

//! Den Token zu bekommen dauert ewig. Liegt es an dieser methode oder daran, dass ich vorher den token von den sharedpreferences genommen hab?
    final String? token = await getIt<FirebaseAuth>()
        .currentUser
        ?.getIdTokenResult(true)
        .then((value) => value.token);
    Logger().d('Firebase token is $token');

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send request. No Firebase id token available in SharedPreferences');
    } else {
      headers ??= {};
      headers['Authorization'] = 'Bearer $token';
      headers['Content-Type'] = 'application/json';

      if (body != null) {
        body[StringConstants.spDBTimestamp] =
            getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      }
      Logger().d('Request body is $body');
      final response = await dio.request(
        buildUrlString(pathParts),
        data: body,
        options: Options(
          method: method.toUpperCase(),
          headers: headers,
        ),
      );

      Logger().d('Response is $response');
      return response;
    }
  }

  Future<Response> makeActionRequest({
    required ApiActionModel apiActionModel,
    Map<String, String>? headers,
  }) async {
    bool? isConnected = await getIt<ConnectivityService>().getConnectivity;
    Logger().d('isConnected in makeRequest is $isConnected');

    if (isConnected == null || isConnected == false) {
      throw NotConnectedToTheInternetError();
    }

//! Den Token zu bekommen dauert ewig. Liegt es an dieser methode oder daran, dass ich vorher den token von den sharedpreferences genommen hab?
    final String? token = await getIt<FirebaseAuth>()
        .currentUser
        ?.getIdTokenResult(true)
        .then((value) => value.token);
    Logger().d('Firebase token is $token');

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send request. No Firebase id token available in SharedPreferences');
    } else {
      headers ??= {};
      headers['Authorization'] = 'Bearer $token';
      headers['Content-Type'] = 'application/json';

      if (apiActionModel.body != null) {
        apiActionModel.body[StringConstants.spDBTimestamp] =
            getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      }

      final response = await dio.request(
        apiActionModel.fullUrl,
        data: apiActionModel.body,
        options: Options(
          method: apiActionModel.method.toUpperCase(),
          headers: headers,
        ),
      );

      Logger().d('Response is $response');
      return response;
    }
  }

  @override
  Future<bool> addTodoToSpecificList({required TodoModel todoModel}) async {
    try {
      Map<String, dynamic> mapToSend = todoModel.toMap();
      Logger().i("Todo as Map: $mapToSend");
      // mapToSend[StringConstants.spDBTimestamp] =
      //     getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      final response = await makeRequest(
          method: 'POST', body: mapToSend, pathParts: [todos]);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().i("Error in addTodoToSpecificList: $e");
      return false;
    }
  }

  @override
  Future<bool> createTodoList({required TodoListModel todoListModel}) async {
    try {
      Map<String, dynamic> mapToSend = todoListModel.toMap();
      Logger().d('Todolist being uploaded as: $mapToSend');

      // mapToSend[StringConstants.spDBTimestamp] =
      //     getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      final response = await makeRequest(
          method: 'POST', body: mapToSend, pathParts: [todolists]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().i("Error in creatTodoList: $e");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAllTodoListsFromBackend() async {
    try {
      final response = await makeRequest(
        method: 'GET',
        pathParts: [todolists],
      );
      Logger().i("Response in getAllTodoListsFromBackend is $response");
      Logger().i(
          "statuscode in getAllTodoListsFromBackend is ${response.statusCode}");
      if (response.statusCode == 200) {
        Logger().i(
            " Responsebody in getAllTodoListsFromBackend is ${response.data}");
        //! Wann muss man jsondecode machen und wann nicht? Es kommt wohl drauf an, was das backend sendet
        //! getallists wird vom backend mit res.status(200).json({"todoLists": todolists }); gesendet, also mit .json

        //  final responseBody = jsonDecode(response.data);
        final responseBody = response.data;
        //final decodedResponseBody = jsonDecode(response.data); stürzt ab

        return responseBody;
      } else {
        return null;
      }
    } catch (e) {
      Logger().i("Error getting all lists: $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getDataInfo() async {
    try {
      final response = await makeRequest(
        pathParts: [dataInfoEndpoint],
        method: 'GET',
      );
      Logger().d('Response in getdata is $response');
      if (response.statusCode == 200) {
        //final Map<String, dynamic>? responseBody = jsonDecode(response.data);
        final responseBody = response.data;
        Logger().d('Response body in getdata is $responseBody');
        return {
          "dataInfo": FirestoreDataInfoModel(
              timestamp: responseBody[StringConstants.spDBTimestamp],
              count: responseBody[StringConstants.firestoreFieldNumberOfLists]),
        };
        // } else {
        //   return null;
      }
    } on NotConnectedToTheInternetError catch (e) {
      Logger().e("Not connected to internet error $e");
      return {"dataInfo": FirestoreDataInfoModel(dataIsAcessible: false)};
    } on DioException catch (e) {
      Logger().e("Catching DioException 404");
      if (e.response?.statusCode == 404) {
        return {"dataInfo": FirestoreDataInfoModel(userDocExists: false)};
      }
    } catch (e) {
      Logger().e("Error getting data info: $e");
      return null;
    }
  }

  @override
  Future<bool> uploadSyncPendingTodoLists() async {
    final data = await DatabaseHelper.getAllEntriesOfsyncPendigTodolists();
    Logger().d('Uploading Todolists in syncPendigTodoLists');
    for (Map entry in data['syncPendigTodoLists']) {
      final TodoListModel todoListModel =
          await DatabaseHelper.getSpecificTodoList(
              uid: entry[DatabaseHelper.syncPendigTodolistsFieldUid]);
      final uploadSuccessful =
          await createTodoList(todoListModel: todoListModel);

      if (uploadSuccessful) {
        await DatabaseHelper.deleteFromsyncPendigTodolists(
            todoListModel: todoListModel);
      }
    }
    return true;
  }

  @override
  Future<bool> syncSyncPendingTodos() async {
    final data = await DatabaseHelper.getAllEntriesOfsyncPendigTodos();
    Logger().d('Syncing Todos in syncPendigTodos');

    for (Map entry in data['syncPendigTodos']) {
      final TodoModel? todoModel = await DatabaseHelper.getSpecificTodo(
          uid: entry[DatabaseHelper.syncPendigTodosFieldUid]);

      if (todoModel != null) {
        final uploadSuccessful =
            await addTodoToSpecificList(todoModel: todoModel);

        if (uploadSuccessful) {
          await DatabaseHelper.deleteFromsyncPendigTodos(uid: todoModel.uid!);
        }
      } else {
        final deleteSuccessful = await deleteTodoFromSpecificList(map: {
          "todolistUid":
              entry[DatabaseHelper.syncPendigTodosFieldParentTodoListUid],
          "uid": entry[DatabaseHelper.syncPendigTodosFieldUid]
        });
        if (deleteSuccessful) {
          await DatabaseHelper.deleteFromsyncPendigTodos(
              uid: entry[DatabaseHelper.syncPendigTodosFieldUid]);
        }
      }
    }
    return true;
  }

  @override
  Future<bool> performApiAction(
      {required ApiActionModel apiActionModel}) async {
    try {
      final response = await makeActionRequest(apiActionModel: apiActionModel);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      Logger().e('performApiAction DioExcetion: $e');
      return false;
    } catch (e) {
      Logger().e('performApiAction error $e');
      return false;
    }
  }

  @override
  Future deleteTodoFromSpecificList({required Map<String, dynamic> map}) async {
    try {
      final response =
          await makeRequest(method: 'DELETE', body: map, pathParts: [todos]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().e("Error in deleteTodoFromSpecificList: $e");
      return false;
    }
  }
}
// @override
// Future<bool> synchronizeAllTodoListsWithBackend(
//     List<TodoListModel> todoLists) {
//   // TODO: implement synchronizeAllTodoListsWithBackend
//   throw UnimplementedError();
// }
