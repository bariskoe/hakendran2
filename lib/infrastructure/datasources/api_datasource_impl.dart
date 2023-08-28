import 'dart:convert';
import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/models/todolist_model.dart';
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiDatasourceImpl implements ApiDatasource {
  final String apiUrl =
      'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction/synchronizelists';

//Checken, ob Future<String die beste Lösung ist>
  Future<String> sendPostRequest(Map<String, dynamic> body) async {
    final String? token = getIt<SharedPreferences>()
        .getString(StringConstants.spFirebaseIDTokenKey);

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send POST request. No Firebase id token available in SharedPreferences');
    } else {
      print('token is $token');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final responseBody = response.body;
        return responseBody;
      } else {
        throw Exception('Failed to send POST request');
      }
    }
  }

  Future<Map<String, dynamic>> sendGetRequest(String url) async {
    final String? token = getIt<SharedPreferences>()
        .getString(StringConstants.spFirebaseIDTokenKey);

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send POST request. No Firebase id token available in SharedPreferences');
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
        throw Exception('Failed to send POST request');
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
      await sendPostRequest(mapToSend);
      return true;
    } catch (e) {
      Logger().i("Error syncing todo list: $e");
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAllTodoListsFromBackend() async {
    final String url =
        'https://europe-north1-geometric-timer-396214.cloudfunctions.net/hakendranBackendDebugFunction/getalllists';

    try {
      final dataFromBackend = await sendGetRequest(url);
      return dataFromBackend;
    } catch (e) {
      Logger().i("Error getting all lists: $e");
      return null;
    }
  }
}
