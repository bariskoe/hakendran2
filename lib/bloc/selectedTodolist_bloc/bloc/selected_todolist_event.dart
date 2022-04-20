part of 'selected_todolist_bloc.dart';

abstract class SelectedTodolistEvent extends Equatable {
  const SelectedTodolistEvent();

  @override
  List<Object> get props => [];
}

class SelectedTodoListEventSelectSpecificTodoList
    extends SelectedTodolistEvent {
  final int id;
  const SelectedTodoListEventSelectSpecificTodoList({required this.id});
  @override
  List<Object> get props => [id];
}

class SelectedTodolistEventUnselect extends SelectedTodolistEvent {}

class SelectedTodolistEventLoadSelectedTodolist extends SelectedTodolistEvent {
  final int id;
  const SelectedTodolistEventLoadSelectedTodolist({
    required this.id,
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
      {required this.id, required this.accomplished});
  final int id;
  final bool accomplished;

  @override
  List<Object> get props => [id, accomplished];
}

class SelectedTodolistEventUpdateTodo extends SelectedTodolistEvent {
  final TodoModel todoModel;
  const SelectedTodolistEventUpdateTodo({required this.todoModel});

  @override
  List<Object> get props => [todoModel];
}

class SelectedTodolistEventDeleteSpecificTodo extends SelectedTodolistEvent {
  final int id;
  const SelectedTodolistEventDeleteSpecificTodo({required this.id});

  @override
  List<Object> get props => [id];
}

class SelectedTodoListEventResetAll extends SelectedTodolistEvent {
  const SelectedTodoListEventResetAll();
}
