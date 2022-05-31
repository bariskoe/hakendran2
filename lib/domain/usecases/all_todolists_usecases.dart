import '../entities/todolist_entity.dart';
import 'package:dartz/dartz.dart';

import '../failures/failures.dart';
import '../repositories/all_todolists_repository.dart';

class AllTodoListsUsecases {
  final AllTodoListsRepository allTodoListsRepository;
  AllTodoListsUsecases({required this.allTodoListsRepository});

  Future<Either<Failure, int>> createNewTodoList({
    required TodoListEntity todoListEntity,
  }) async {
    return allTodoListsRepository.createNewTodoList(
        todoListEntity: todoListEntity);
  }
}
