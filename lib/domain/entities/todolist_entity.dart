import 'todo_entity.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';

class TodoListEntity with EquatableMixin {
  //! Should the uid
  final String? uid;

  final String listName;
  //! This has to be List<TodoEntity>
  final List<TodoEntity> todoEntities;
  final TodoListCategory todoListCategory;

  TodoListEntity({
    required this.listName,
    this.todoEntities = const [],
    this.todoListCategory = TodoListCategory.none,
    this.uid,
  });

  @override
  List<Object?> get props => [
        listName,
        todoEntities,
        todoListCategory,
      ];

  int get numberOfUnaccomplishedTodos =>
      numberOfTodos - numberOfAccomplishedTodos;

  double get percentageOfAccomplishedTodos =>
      numberOfAccomplishedTodos / numberOfTodos;

  int get numberOfTodos => todoEntities.length;

  int get numberOfAccomplishedTodos =>
      todoEntities.where((element) => element.accomplished).length;
  bool get allAccomplished =>
      (todoEntities.isNotEmpty && numberOfAccomplishedTodos == numberOfTodos);

  bool get atLeastOneAccomplished =>
      (todoEntities.isNotEmpty && numberOfAccomplishedTodos > 0);
}
