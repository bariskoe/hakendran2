import '../entities/todolist_entity.dart';
import '../failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class SelectedTodolistRepository {
  Future<Either<Failure, TodoListEntity>> getSpecificTodoList(
      {required int id});
}
