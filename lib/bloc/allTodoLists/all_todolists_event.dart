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
  final String uuid;
  const AllTodolistsEventDeleteSpecificTodolist({required this.uuid});

  @override
  List<Object> get props => [id];
}

class AllTodoListEventUpdateListParameters extends AllTodolistsEvent {
  final String uuid;
  final String listName;
  final TodoListCategory todoListCategory;
  const AllTodoListEventUpdateListParameters({
    required this.uuid,
    required this.listName,
    required this.todoListCategory,
  });

  @override
  List<Object> get props => [
        uuid,
        listName,
        todoListCategory,
      ];
}

class AllTodoListEventCheckRepeatPeriodsAndResetAccomplishedIfNeccessary
    extends AllTodolistsEvent {}

//  Overwrites the state of the Firebase data with the data in the local database
class AllTodolistsEventSynchronizeAllTodoListsWithBackend
    extends AllTodolistsEvent {}

class AllTodoListEvenGetAllTodoListsFromBackend extends AllTodolistsEvent {}
