import '../../../models/todolist_model.dart';
import '../../../pages/todo_detail_page.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/databse_helper.dart';
import '../../../models/todo_model.dart';

part 'selected_todolist_event.dart';
part 'selected_todolist_state.dart';

class SelectedTodolistBloc
    extends Bloc<SelectedTodolistEvent, SelectedTodolistState> {
  SelectedTodolistBloc() : super(SelectedTodolistInitial()) {
    int? selectedTodoList;

    String nameOfSelectedTodoList = '';
    TodoListCategory? categoryOfSelectedList;

    /*
    on<>((event, emit) async {
    
      });
    */
    on<SelectedTodolistEvent>((event, emit) async {});

    on<SelectedTodolistEventLoadSelectedTodolist>((event, emit) async {
      List<TodoModel> list = await DatabaseHelper.getTodosOfSpecificList(
          listId: selectedTodoList!);
      emit(SelectedTodolistStateLoaded(
          id: selectedTodoList!,
          listName: nameOfSelectedTodoList,
          todoListCategory: categoryOfSelectedList ?? TodoListCategory.none,
          todos: list));
    });
    on<SelectedTodolistEventAddNewTodo>((event, emit) async {
      event.todoModel.parentTodoListId = selectedTodoList;

      TodoListDetailPage.justAddedTodo = true;
      await DatabaseHelper.addTodoToSpecificList(event.todoModel);
      add(SelectedTodolistEventLoadSelectedTodolist());
    });

    on<SelectedTodolistEventUnselect>((event, emit) async {
      selectedTodoList = null;
      nameOfSelectedTodoList = '';
      categoryOfSelectedList = null;
    });

    on<SelectedTodoListEventSelectSpecificTodoList>((event, emit) async {
      selectedTodoList = event.id;

      nameOfSelectedTodoList =
          await DatabaseHelper.getNameOfTodoListById(listId: event.id);
      categoryOfSelectedList =
          await DatabaseHelper.getCategoryOfTodoListById(listId: event.id);
    });

    on<SelectedTodolistEventUpdateAccomplishedOfTodo>(
      (event, emit) async {
        await DatabaseHelper.setAccomplishmentStatusOfTodo(
            id: event.id, accomplished: event.accomplished);

        add(SelectedTodolistEventLoadSelectedTodolist());
      },
    );

    on<SelectedTodolistEventUpdateTodo>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      await DatabaseHelper.updateSpecificTodo(model: event.todoModel);
      add(SelectedTodolistEventLoadSelectedTodolist());
    });

    on<SelectedTodolistEventDeleteSpecificTodo>((event, emit) async {
      await DatabaseHelper.deleteSpecificTodo(id: event.id);
      add(SelectedTodolistEventLoadSelectedTodolist());
    });

    on<SelectedTodoListEventResetAll>((event, emit) async {
      DatabaseHelper.resetAllTodosOfSpecificList(id: selectedTodoList!);
      add(SelectedTodolistEventLoadSelectedTodolist());
    });
  }
}
