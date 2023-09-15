import 'package:dartz/dartz.dart';

import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../failures/failures.dart';

abstract class ApiRepository {
  Future<Either<Failure, bool>> createTodoList({
    required TodoListModel todoListModel,
  });

  Future<Either<Failure, bool>> addTodoToSpecificList({
    required TodoModel todoModel,
  });
}
