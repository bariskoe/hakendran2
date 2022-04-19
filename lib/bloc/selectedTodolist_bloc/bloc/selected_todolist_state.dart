part of 'selected_todolist_bloc.dart';

abstract class SelectedTodolistState extends Equatable {
  const SelectedTodolistState();

  @override
  List<Object> get props => [];
}

class SelectedTodolistInitial extends SelectedTodolistState {}

class SelectedTodolistStateLoaded extends SelectedTodolistState {
  final int id;
  final String listName;
  final TodoListCategory todoListCategory;
  final List<TodoModel> todos;

  const SelectedTodolistStateLoaded({
    required this.id,
    required this.listName,
    required this.todoListCategory,
    required this.todos,
  });

  @override
  List<Object> get props => [
        id,
        listName,
        todoListCategory,
        todos,
      ];
}

class SelectedTodoListStateLoading extends SelectedTodolistState {}
