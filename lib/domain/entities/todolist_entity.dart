import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

class TodoListEntity {
  final String? uid;

  final String listName;
  final List<TodoModel> todoModels;
  final TodoListCategory todoListCategory;

  TodoListEntity({
    required this.listName,
    this.todoModels = const [],
    this.todoListCategory = TodoListCategory.none,
    this.uid,
  });

  TodoListModel toModel() {
    return TodoListModel(
        uid: uid,
        listName: listName,
        todoModels: todoModels,
        todoListCategory: todoListCategory);
  }
}
