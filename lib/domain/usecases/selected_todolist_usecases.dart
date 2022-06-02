import '../entities/todolist_entity.dart';
import '../failures/failures.dart';
import '../repositories/selected_todolist_repository.dart';
import 'package:dartz/dartz.dart';

class SelectedTodolistUsecases {
  final SelectedTodolistRepository selectedTodolistRepository;
  SelectedTodolistUsecases({required this.selectedTodolistRepository});

  Future<Either<Failure, TodoListEntity>> getSpecificTodoLis(
      {required int id}) async {
    return await selectedTodolistRepository.getSpecificTodoList(id: id);
  }
}
