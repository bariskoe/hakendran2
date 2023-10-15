import 'package:baristodolistapp/domain/parameters/todo_parameters.dart';

import '../parameters/todolist_entity_parameters.dart';
import '../../models/api_action_model.dart';
import 'package:dartz/dartz.dart';

import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../failures/failures.dart';

abstract class ApiRepository {
  Future<Either<Failure, bool>> createTodoList({
    required TodoListEntityParameters todoListEntityParameters,
  });

  Future<Either<Failure, bool>> addTodoToSpecificList({
    required TodoParameters todoParameters,
  });

  Future<Either<Failure, bool>> performApiAction({
    required ApiActionModel apiActionModel,
  });
}
