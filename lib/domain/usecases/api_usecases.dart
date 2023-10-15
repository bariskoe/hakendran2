import 'package:baristodolistapp/domain/parameters/todo_parameters.dart';

import '../parameters/todolist_entity_parameters.dart';
import '../repositories/api_repository.dart';
import 'package:dartz/dartz.dart';

import '../../models/api_action_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../failures/failures.dart';

class ApiUsecases {
  ApiRepository apiRepository;

  ApiUsecases({
    required this.apiRepository,
  });

  Future<Either<Failure, bool>> createTodoList({
    required TodoListEntityParameters todoListEntityParameters,
  }) async {
    return await apiRepository.createTodoList(
        todoListEntityParameters: todoListEntityParameters);
  }

  Future<Either<Failure, bool>> addTodoToSpecificList({
    required TodoParameters todoParameters,
  }) async {
    return await apiRepository.addTodoToSpecificList(
        todoParameters: todoParameters);
  }

  Future<Either<Failure, bool>> performApiAction({
    required ApiActionModel apiActionModel,
  }) async {
    return await apiRepository.performApiAction(apiActionModel: apiActionModel);
  }
}
