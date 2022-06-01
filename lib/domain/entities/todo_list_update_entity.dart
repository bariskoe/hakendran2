import '../../models/todolist_model.dart';

class TodoListUpdateEntity {
  int id;
  String listName;
  TodoListCategory todoListCategory;

  TodoListUpdateEntity({
    required this.id,
    required this.listName,
    required this.todoListCategory,
  });
}
