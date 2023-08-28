import '../../models/todo_list_update_model.dart';

import '../../models/todolist_model.dart';
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

  Future<Either<Failure, List<TodoListModel>>> getAllTodoLists() async {
    return allTodoListsRepository.getAllTodoLists();
  }

  Future<Either<Failure, bool>> synchronizeAllTodoListsWithBackend(
      List<TodoListModel> todoLists) async {
    return allTodoListsRepository.synchronizeAllTodoListsWithBackend(
        todoLists: todoLists);
  }

  Future<Either<Failure, Map<String, dynamic>?>> getAllTodoListsFromBackend() {
    return allTodoListsRepository.getAllTodoListsFromBackend();
  }

  Future<Either<Failure, int>> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel}) {
    return allTodoListsRepository.updateSpecificListParameters(
        todoListUpdateModel: todoListUpdateModel);
  }

  Future<Either<Failure, int>> deleteSpecifiTodoList({required String uuid}) {
    return allTodoListsRepository.deleteSpecifiTodoList(uuid: uuid);
  }

  Future<Either<Failure, bool>>
      checkRepeatPeriodsAndResetAccomplishedIfNeccessary() {
    return allTodoListsRepository
        .checkRepeatPeriodsAndResetAccomplishedIfNeccessary();
  }

  Future<Either<Failure, int>> deleteAllTodoLists() {
    return allTodoListsRepository.deleteAllTodoLists();
  }
}
