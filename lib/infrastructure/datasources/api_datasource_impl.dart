import 'dart:convert';
import 'package:baristodolistapp/bloc/authentication/authentication_bloc.dart';
import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/models/todo_model.dart';
import 'package:baristodolistapp/models/todolist_model.dart';
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiDatasourceImpl implements ApiDatasource {
  final String apiUrl =
      'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction/synchronizelists';

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

//Checken, ob Future<String die beste Lösung ist>
  Future<Response> sendPostRequest({
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

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      return response;

      // if (response.statusCode == 200) {
      //   final responseBody = response.body;
      //   return responseBody;
      // } else {
      //   throw Exception('Failed to send POST request');
      // }
    }
  }

  Future<Map<String, dynamic>> sendGetRequest(String url) async {
    final String? token =
        // getIt<SharedPreferences>().getString(StringConstants.spFirebaseIDTokenKey);
        await getIt<FirebaseAuth>()
            .currentUser
            ?.getIdTokenResult(true)
            .then((value) => value.token);

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send GET request. No Firebase id token available in SharedPreferences');
    } else {
      print('token is $token');
      final headers = {
        'Authorization': 'Bearer $token',
        //'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        throw Exception(
            'Failed to send request. Statuscode ${response.statusCode}');
      }
    }
  }

  @override
  Future<bool> synchronizeAllTodoListsWithBackend(
      List<TodoListModel> todoLists) async {
    try {
      Map<String, dynamic> mapToSend = {"lists": []};
      List listWithTodoListsAsMap = [];
      for (var list in todoLists) {
        listWithTodoListsAsMap.add(list.toMap());
      }
      mapToSend["lists"] = listWithTodoListsAsMap;
      mapToSend[StringConstants.spDBTimestamp] =
          getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
      await sendPostRequest(body: mapToSend, pathParts: [synchronizelists]);
      return true;
    } catch (e) {
      Logger().i("Error syncing todo list: $e");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAllTodoListsFromBackend() async {
    const String url =
        'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction/getalllists';

    try {
      final dataFromBackend = await sendGetRequest(url);
      return dataFromBackend;
    } catch (e) {
      Logger().i("Error getting all lists: $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getDataInfo() async {
    final String url = buildUrlString([dataInfoEndpoint]);

    try {
      final dataFromBackend = await sendGetRequest(url);
      return dataFromBackend;
    } catch (e) {
      Logger().i("Error getting data info: $e");
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
}
