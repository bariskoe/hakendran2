import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

class TodoListEntity {
  final int? id;

  final String listName;
  final List<TodoModel> todoModels;
  final TodoListCategory todoListCategory;

  TodoListEntity({
    required this.id,
    required this.listName,
    required this.todoModels,
    this.todoListCategory = TodoListCategory.none,
  });
}
