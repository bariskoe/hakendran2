/*
import 'dart:convert';

import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/models/todo_model.dart';
import 'package:baristodolistapp/models/todolist_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../dependency_injection.dart';

class ApiDataSourceImplNew implements ApiDatasource {
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
    Map<String, String> headers = const {},
    Map<String, dynamic>? body,
  }) async {
    final String? token = await getIt<FirebaseAuth>()
        .currentUser
        ?.getIdTokenResult(true)
        .then((value) => value.token);

    if (token == null || token.isEmpty) {
      throw Exception(
          'Failed to send request. No Firebase id token available in SharedPreferences');
    } else {
      // final headers = {
      //   'Authorization': 'Bearer $token',
      //   //'Content-Type': 'application/json',
      // };

      headers['Authorization'] = 'Bearer $token';
      try {
        final response = await dio.request(
          buildUrlString(pathParts),
          data: body,
          options: Options(
            method: method.toUpperCase(),
            headers: headers,
          ),
        );
        return response;
      } catch (e) {
        throw Exception('Failed to send request.');
      }
    }
  }

  @override
  Future addTodoToSpecificList({required TodoModel todoModel}) {
    Logger().d('nix');
    return null;
  }

  @override
  Future<bool> createTodoList({required TodoListModel todoListModel}) {
    // TODO: implement createTodoList
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getAllTodoListsFromBackend() {
    // TODO: implement getAllTodoListsFromBackend
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getDataInfo() async {
    
      final response = await makeRequest(
        pathParts: [dataInfoEndpoint],
        method: 'GET',
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.data);
        return responseBody;
      } else {
      return null; 
      }
    } 
  }

  @override
  Future<bool> synchronizeAllTodoListsWithBackend(
      List<TodoListModel> todoLists) {
    // TODO: implement synchronizeAllTodoListsWithBackend
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadSyncPendingTodoLists() {
    // TODO: implement uploadSyncPendingTodoLists
    throw UnimplementedError();
  }
}


*/