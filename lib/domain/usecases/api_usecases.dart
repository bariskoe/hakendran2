import 'package:dartz/dartz.dart';

import '../../models/api_action_model.dart';
import '../../models/todo_model.dart';
import '../failures/failures.dart';
import '../parameters/todolist_entity_parameters.dart';
import '../repositories/api_repository.dart';

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
    required TodoModel todoModel,
  }) async {
    return await apiRepository.addTodoToSpecificList(todoModel: todoModel);
  }

  Future<Either<Failure, bool>> performApiAction({
    required ApiActionModel apiActionModel,
  }) async {
    return await apiRepository.performApiAction(apiActionModel: apiActionModel);
  }
}
