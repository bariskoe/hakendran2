part of 'selected_todolist_bloc.dart';

abstract class SelectedTodolistEvent extends Equatable {
  const SelectedTodolistEvent();

  @override
  List<Object> get props => [];
}

class SelectedTodoListEventSelectSpecificTodoList
    extends SelectedTodolistEvent {
  final String uuid;
  const SelectedTodoListEventSelectSpecificTodoList({required this.uuid});
  @override
  List<Object> get props => [uuid];
}

class SelectedTodolistEventUnselect extends SelectedTodolistEvent {}

class SelectedTodolistEventLoadSelectedTodolist extends SelectedTodolistEvent {
  final String uuid;
  const SelectedTodolistEventLoadSelectedTodolist({
    required this.uuid,
  });
}

class SelectedTodolistEventAddNewTodo extends SelectedTodolistEvent {
  final TodoModel todoModel;
  const SelectedTodolistEventAddNewTodo({required this.todoModel});

  @override
  List<Object> get props => [todoModel];
}

class SelectedTodolistEventUpdateAccomplishedOfTodo
    extends SelectedTodolistEvent {
  const SelectedTodolistEventUpdateAccomplishedOfTodo(
      {required this.uuid, required this.accomplished});
  final String uuid;
  final bool accomplished;

  @override
  List<Object> get props => [uuid, accomplished];
}

class SelectedTodolistEventUpdateTodo extends SelectedTodolistEvent {
  final TodoModel todoModel;
  const SelectedTodolistEventUpdateTodo({required this.todoModel});

  @override
  List<Object> get props => [todoModel];
}

class SelectedTodolistEventDeleteSpecificTodo extends SelectedTodolistEvent {
  final String uuid;
  const SelectedTodolistEventDeleteSpecificTodo({required this.uuid});

  @override
  List<Object> get props => [uuid];
}

class SelectedTodoListEventResetAll extends SelectedTodolistEvent {
  const SelectedTodoListEventResetAll();
}

class SelectedTodoListEventAddTodoListUidToSyncPendingTodoLists
    extends SelectedTodolistEvent {
  final String uid;
  const SelectedTodoListEventAddTodoListUidToSyncPendingTodoLists(
    this.uid,
  );

  @override
  List<Object> get props => [uid];
}
