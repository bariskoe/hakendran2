import 'package:baristodolistapp/domain/repositories/api_repository.dart';
import 'package:dartz/dartz.dart';

import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../failures/failures.dart';

class ApiUsecases {
  ApiRepository apiRepository;

  ApiUsecases({
    required this.apiRepository,
  });

  Future<Either<Failure, bool>> createTodoList({
    required TodoListModel todoListModel,
  }) async {
    return await apiRepository.createTodoList(todoListModel: todoListModel);
  }

  Future<Either<Failure, bool>> addTodoToSpecificList({
    required TodoModel todoModel,
  }) async {
    return await apiRepository.addTodoToSpecificList(todoModel: todoModel);
  }
}
