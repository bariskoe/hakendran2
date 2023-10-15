import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

class TodoListEntity with EquatableMixin {
  //! Should the uid
  final String? uid;

  final String listName;
  //! This has to be List<TodoEntity>
  final List<TodoModel> todoModels;
  final TodoListCategory todoListCategory;

  TodoListEntity({
    required this.listName,
    this.todoModels = const [],
    this.todoListCategory = TodoListCategory.none,
    this.uid,
  });

//! There should not be a toModel function. In the model there should be a fromDomain function

  TodoListModel toModel() {
    return TodoListModel(
        uid: uid,
        listName: listName,
        todoModels: todoModels,
        todoListCategory: todoListCategory);
  }

  @override
  List<Object?> get props => [
        listName,
        todoModels,
        todoListCategory,
      ];
}
