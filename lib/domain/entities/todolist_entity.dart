import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

class TodoListEntity {
  final int? id;
  final String? uuid;

  final String listName;
  final List<TodoModel> todoModels;
  final TodoListCategory todoListCategory;

  TodoListEntity({
    required this.listName,
    this.todoModels = const [],
    this.id,
    this.todoListCategory = TodoListCategory.none,
    this.uuid,
  });

  TodoListModel toModel() {
    return TodoListModel(
        uuid: uuid,
        id: id,
        listName: listName,
        todoModels: todoModels,
        todoListCategory: todoListCategory);
  }
}
