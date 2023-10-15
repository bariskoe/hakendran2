part of 'selected_todolist_bloc.dart';

abstract class SelectedTodolistEvent extends Equatable {
  const SelectedTodolistEvent();

  @override
  List<Object> get props => [];
}

class SelectedTodoListEventSelectSpecificTodoList
    extends SelectedTodolistEvent {
  final String uid;
  const SelectedTodoListEventSelectSpecificTodoList({required this.uid});
  @override
  List<Object> get props => [uid];
}

class SelectedTodolistEventUnselect extends SelectedTodolistEvent {}

class SelectedTodolistEventLoadSelectedTodolist extends SelectedTodolistEvent {
  final String uid;
  final bool synchronize;
  const SelectedTodolistEventLoadSelectedTodolist(
      {required this.uid, this.synchronize = true});
}

class SelectedTodolistEventAddNewTodo extends SelectedTodolistEvent {
  final TodoParameters todoParameters;
  const SelectedTodolistEventAddNewTodo({required this.todoParameters});

  @override
  List<Object> get props => [todoParameters];
}

class SelectedTodolistEventUpdateAccomplishedOfTodo
    extends SelectedTodolistEvent {
  const SelectedTodolistEventUpdateAccomplishedOfTodo(
      {required this.uid, required this.accomplished});
  final String uid;
  final bool accomplished;

  @override
  List<Object> get props => [uid, accomplished];
}

class SelectedTodolistEventUpdateTodo extends SelectedTodolistEvent {
  final TodoParameters todoParameters;
  const SelectedTodolistEventUpdateTodo({required this.todoParameters});

  @override
  List<Object> get props => [todoParameters];
}

class SelectedTodolistEventDeleteSpecificTodo extends SelectedTodolistEvent {
  final TodoParameters todoParameters;
  const SelectedTodolistEventDeleteSpecificTodo({required this.todoParameters});

  @override
  List<Object> get props => [todoParameters];
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

class SelectedTodoListEventAddTodoUidToSyncPendingTodos
    extends SelectedTodolistEvent {
  final TodoParameters todoParameters;

  const SelectedTodoListEventAddTodoUidToSyncPendingTodos({
    required this.todoParameters,
  });

  @override
  List<Object> get props => [todoParameters];
}
