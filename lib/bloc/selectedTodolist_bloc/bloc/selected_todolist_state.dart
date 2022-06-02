part of 'selected_todolist_bloc.dart';

abstract class SelectedTodolistState extends Equatable {
  const SelectedTodolistState();

  @override
  List<Object> get props => [];
}

class SelectedTodolistInitial extends SelectedTodolistState {}

class SelectedTodolistStateLoaded extends SelectedTodolistState {
  final TodoListModel todoListModel;

  const SelectedTodolistStateLoaded({
    required this.todoListModel,
  });

  @override
  List<Object> get props => [todoListModel];
}

class SelectedTodoListStateLoading extends SelectedTodolistState {}

class SelectedTodolistStateError extends SelectedTodolistState {}
