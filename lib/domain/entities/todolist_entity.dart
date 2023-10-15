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

  @override
  List<Object?> get props => [
        listName,
        todoModels,
        todoListCategory,
      ];

  int get numberOfUnaccomplishedTodos =>
      numberOfTodos - numberOfAccomplishedTodos;

  double get percentageOfAccomplishedTodos =>
      numberOfAccomplishedTodos / numberOfTodos;

  int get numberOfTodos => todoModels.length;

  int get numberOfAccomplishedTodos =>
      todoModels.where((element) => element.accomplished).length;
  bool get allAccomplished =>
      (todoModels.isNotEmpty && numberOfAccomplishedTodos == numberOfTodos);

  bool get atLeastOneAccomplished =>
      (todoModels.isNotEmpty && numberOfAccomplishedTodos > 0);
}
