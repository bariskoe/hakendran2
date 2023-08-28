part of 'all_todolists_bloc.dart';

abstract class AllTodolistsState extends Equatable {
  const AllTodolistsState();

  @override
  List<Object> get props => [];
}

class AllTodoListsStateLoading extends AllTodolistsState {}

// Can be used during upload to or download from backend
class AllTodoListsStateSynchronizingWithBackend extends AllTodolistsState {}

class AllTodoListsStateError extends AllTodolistsState {}

class AllTodolistsInitial extends AllTodolistsState {}

class AllTodoListsStateLoaded extends AllTodolistsState {
  final List<TodoListModel> listOfAllLists;

  const AllTodoListsStateLoaded({required this.listOfAllLists});

  @override
  List<Object> get props => [listOfAllLists];
}

class AllTodoListsStateListEmpty extends AllTodolistsState {}

class AllTodoListsStateDataPreparationComplete extends AllTodolistsState {}
