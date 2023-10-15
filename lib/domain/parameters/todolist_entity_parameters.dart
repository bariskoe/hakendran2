// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/models/todolist_model.dart';

import '../../models/todo_model.dart';

class TodoListEntityParameters {
  final String? uid;

  final String? listName;
  //! This has to be List<TodoEntity>
  final List<TodoModel>? todoModels;
  final TodoListCategory? todoListCategory;

  TodoListEntityParameters({
    this.uid,
    this.listName,
    this.todoModels,
    this.todoListCategory,
  });
}
