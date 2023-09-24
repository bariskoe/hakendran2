//!This is the old version of the ApiDatasource. It was replaced by the new ApiDatasource whicch works with the Dio package
/*
import 'dart:convert';

import 'package:baristodolistapp/database/databse_helper.dart';
import 'package:baristodolistapp/domain/errors/errors.dart';
import 'package:baristodolistapp/models/firestore_data_info_model.dart';
import 'package:baristodolistapp/services/connectivity_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dependency_injection.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../../strings/string_constants.dart';
import 'api_datasource.dart';

class ApiDatasourceImpl implements ApiDatasource {
  final baseUrl =
      'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction';

  final dataInfoEndpoint = 'getdatainfo';
  final synchronizelists = 'synchronizelists';
  final createtodolist = 'createtodolist';
  final createtodo = 'createtodo';

  String buildUrlString(List<String> paths) {
    String url = baseUrl;
    for (String path in paths) {
      url = url + '/$path';
    }
    return url;
  }

  Future<http.Response> sendPostRequest({
    required Map<String, dynamic> body,
    required List<String> pathParts,
  }) async {
    final idToken = await getIt<FirebaseAuth>().currentUser?.getIdToken(true);

    if (idToken != null) {
      getIt<SharedPreferences>()
          .setString(StringConstants.spFirebaseIDTokenKey, idToken);
    }

    final url = buildUrlString(pathParts);
    final String? token = getIt<SharedPreferences>()
        .getString(StringConstants.spFirebaseIDTokenKey);

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send POST request. No Firebase id token available in SharedPreferences');
    } else {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      body[StringConstants.spDBTimestamp] =
          getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      return response;
    }
  }

  Future<http.Response> sendGetRequest(String url) async {
    bool? isConnected = await getIt<ConnectivityService>().getConnectivity;
    Logger().d('isConnected in sendGetRequest is $isConnected');

    if (isConnected == null || isConnected == false) {
      throw NotConnectedToTheInternetError();
    }

    final String? token = await getIt<FirebaseAuth>()
        .currentUser
        ?.getIdTokenResult(true)
        .then((value) => value.token);

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send GET request. No Firebase id token available in SharedPreferences');
    } else {
      final headers = {
        'Authorization': 'Bearer $token',
        //'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      // if (response.statusCode == 200) {
      //   final responseBody = jsonDecode(response.body);
      //   return responseBody;
      // } else if (response.statusCode == 404) {
      //   throw NoSuchUserError();
      // } else {
      //   throw Exception('Exception in get request ${response.statusCode},');
      // }
      return response;
    }
  }

  // @override
  // Future<bool> synchronizeAllTodoListsWithBackend(
  //     List<TodoListModel> todoLists) async {
  //   try {
  //     Map<String, dynamic> mapToSend = {"lists": []};
  //     List listWithTodoListsAsMap = [];
  //     for (var list in todoLists) {
  //       listWithTodoListsAsMap.add(list.toMap());
  //     }
  //     mapToSend["lists"] = listWithTodoListsAsMap;
  //     mapToSend[StringConstants.spDBTimestamp] =
  //         getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
  //     await sendPostRequest(body: mapToSend, pathParts: [synchronizelists]);
  //     return true;
  //   } catch (e) {
  //     Logger().i("Error syncing todo list: $e");
  //     return false;
  //   }
  // }

  @override
  Future<Map<String, dynamic>?> getAllTodoListsFromBackend() async {
    const String url =
        'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction/getalllists';

    try {
      final response = await sendGetRequest(url);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        return responseBody;
      }
    } catch (e) {
      Logger().i("Error getting all lists: $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getDataInfo() async {
    final String url = buildUrlString([dataInfoEndpoint]);

    try {
      final response = await sendGetRequest(url);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          "dataInfo": FirestoreDataInfoModel(
              timestamp: responseBody[StringConstants.spDBTimestamp],
              count: responseBody[StringConstants.firestoreFieldNumberOfLists]),
        };
      } else if (response.statusCode == 404) {
        return {"dataInfo": FirestoreDataInfoModel(userDocExists: false)};
      }
    } on NotConnectedToTheInternetError catch (e) {
      Logger().e("Not connected to internet error $e");
      return {"dataInfo": FirestoreDataInfoModel(dataIsAcessible: false)};
    } catch (e) {
      Logger().e("Error getting data info: $e");
      return null;
    }
  }

  @override
  Future<bool> createTodoList({required TodoListModel todoListModel}) async {
    try {
      Map<String, dynamic> mapToSend = todoListModel.toMap();
      Logger().d('Todolist being uploaded as: $mapToSend');

      mapToSend[StringConstants.spDBTimestamp] =
          getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      final response =
          await sendPostRequest(body: mapToSend, pathParts: [createtodolist]);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().i("Error syncing todo list: $e");
      return false;
    }
  }

  @override
  Future<bool> addTodoToSpecificList({required TodoModel todoModel}) async {
    try {
      Map<String, dynamic> mapToSend = todoModel.toMap();
      Logger().i("Todo as Map: $mapToSend");
      mapToSend[StringConstants.spDBTimestamp] =
          getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      final response =
          await sendPostRequest(body: mapToSend, pathParts: [createtodo]);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().i("Error syncing todo list: $e");
      return false;
    }
  }

  @override
  Future<bool> uploadSyncPendingTodoLists() async {
    final data = await DatabaseHelper.getAllEntriesOfsyncPendigTodolists();

    for (Map entry in data['syncPendigTodoLists']) {
      final TodoListModel todoListModel =
          await DatabaseHelper.getSpecificTodoList(
              uuid: entry[DatabaseHelper.syncPendigTodolistsFieldUid]);
      final uploadSuccessful =
          await createTodoList(todoListModel: todoListModel);

      if (uploadSuccessful) {
        await DatabaseHelper.deleteFromsyncPendigTodolists(
            todoListModel: todoListModel);
      }
    }
    return true;
  }
}

*/