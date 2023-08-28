import '../../models/todolist_model.dart';

class TodoListUpdateEntity {
  String uuid;
  String listName;
  TodoListCategory todoListCategory;

  TodoListUpdateEntity({
    required this.uuid,
    required this.listName,
    required this.todoListCategory,
  });
}
