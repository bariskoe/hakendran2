part of 'all_todolists_bloc.dart';

abstract class AllTodolistsEvent extends Equatable {
  const AllTodolistsEvent();

  @override
  List<Object> get props => [];
}

class AllTodolistsEventCreateNewTodoList extends AllTodolistsEvent {
  final String listName;
  final TodoListCategory todoListCategory;
  const AllTodolistsEventCreateNewTodoList({
    required this.listName,
    required this.todoListCategory,
  });

  @override
  List<Object> get props => [
        listName,
        todoListCategory,
      ];
}

class AllTodolistsEventGetAllTodoLists extends AllTodolistsEvent {}

class AllTodolistsEventDeleteAllTodoLists extends AllTodolistsEvent {}

class AllTodolistsEventDeleteSpecificTodolist extends AllTodolistsEvent {
  final int id;
  const AllTodolistsEventDeleteSpecificTodolist({required this.id});

  @override
  List<Object> get props => [id];
}

class AllTodoListEventUpdateListParameters extends AllTodolistsEvent {
  final int id;
  final String listName;
  final TodoListCategory todoListCategory;
  const AllTodoListEventUpdateListParameters({
    required this.id,
    required this.listName,
    required this.todoListCategory,
  });

  @override
  List<Object> get props => [
        id,
        listName,
        todoListCategory,
      ];
}

class AllTodoListEventCheckRepeatPeriodsAndResetAccomplishedIfNeccessary
    extends AllTodolistsEvent {}
