part of 'selected_todolist_bloc.dart';

abstract class SelectedTodolistState extends Equatable {
  const SelectedTodolistState();

  @override
  List<Object> get props => [];
}

class SelectedTodolistInitial extends SelectedTodolistState {}

class SelectedTodolistStateLoaded extends SelectedTodolistState {
  final TodoListEntity todoListEntity;
  final bool synchronize;

  const SelectedTodolistStateLoaded({
    this.synchronize = true,
    required this.todoListEntity,
  });

  @override
  List<Object> get props => [todoListEntity, synchronize];
}

class SelectedTodoListStateLoading extends SelectedTodolistState {}

class SelectedTodolistStateError extends SelectedTodolistState {}
