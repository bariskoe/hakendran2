import 'package:dartz/dartz.dart';

import '../../models/todo_list_update_model.dart';
import '../../models/todolist_model.dart';
import '../entities/todolist_entity.dart';
import '../failures/failures.dart';

abstract class AllTodoListsRepository {
  /// Calls a function in [DatabaseHelper] to create a new TodoList.
  /// Returns an [int] if the TodoList was saved successfully.
  /// Returns a [DatabaseFailure] if no int is returned from Database
  /// it will return a [GeneralFailure] for all other failures
  Future<Either<Failure, int>> createNewTodoList(
      {required TodoListEntity todoListEntity});

  /// Returns a list of [TodoListModel] which contains all TodoLists
  /// in the database
  Future<Either<Failure, List<TodoListModel>>> getAllTodoLists();

  // Future<Either<Failure, bool>> synchronizeAllTodoListsWithBackend(
  //     {required List<TodoListModel> todoLists});

  Future<Either<Failure, Map<String, dynamic>?>> getAllTodoListsFromBackend();

  // Updates the fields of a specific TodoList. Returns a [DatabaseFailure]
  // if anything goes wrong
  Future<Either<Failure, int>> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel});

  // Deletes the TodoList which has the provided id. Returns a [DatabaseFailure]
  // if anything goes wrong
  Future<Either<Failure, int>> deleteSpecifiTodoList({required String uuid});

  /// Loops through all Todos and checks sets the field "accomplished" to false
  /// if the reset period has passed.
  Future<Either<Failure, bool>>
      checkRepeatPeriodsAndResetAccomplishedIfNeccessary();

  /// Deletes all TodoLists in the Database. Returns a [DatabaseFailure]
  /// if anything goes wrong
  Future<Either<Failure, int>> deleteAllTodoLists();
}
