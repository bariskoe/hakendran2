import '../../models/todolist_model.dart';

class TodoListUpdateEntity {
  String uid;
  String listName;
  TodoListCategory todoListCategory;

  TodoListUpdateEntity({
    required this.uid,
    required this.listName,
    required this.todoListCategory,
  });
}
