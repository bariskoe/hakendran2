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

    /*
    on<>((event, emit) async {
    
      });
    */
    on<SelectedTodolistEvent>((event, emit) async {});

    on<SelectedTodolistEventLoadSelectedTodolist>((event, emit) async {
      TodoListModel model =
          await DatabaseHelper.getSpecificTodoList(id: event.id);
      emit(SelectedTodolistStateLoaded(todoListModel: model));
    });

    on<SelectedTodolistEventAddNewTodo>((event, emit) async {
      event.todoModel.parentTodoListId = selectedTodoList;

      TodoListDetailPage.justAddedTodo = true;
      await DatabaseHelper.addTodoToSpecificList(event.todoModel);
      add(SelectedTodolistEventLoadSelectedTodolist(id: selectedTodoList!));
    });

    on<SelectedTodolistEventUnselect>((event, emit) async {
      selectedTodoList = null;
    });

    on<SelectedTodoListEventSelectSpecificTodoList>((event, emit) async {
      selectedTodoList = event.id;
    });

    on<SelectedTodolistEventUpdateAccomplishedOfTodo>(
      (event, emit) async {
        await DatabaseHelper.setAccomplishmentStatusOfTodo(
            id: event.id, accomplished: event.accomplished);

        add(SelectedTodolistEventLoadSelectedTodolist(id: selectedTodoList!));
      },
    );

    on<SelectedTodolistEventUpdateTodo>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      await DatabaseHelper.updateSpecificTodo(model: event.todoModel);
      add(SelectedTodolistEventLoadSelectedTodolist(id: selectedTodoList!));
    });

    on<SelectedTodolistEventDeleteSpecificTodo>((event, emit) async {
      await DatabaseHelper.deleteSpecificTodo(id: event.id);
      add(SelectedTodolistEventLoadSelectedTodolist(id: selectedTodoList!));
    });

    on<SelectedTodoListEventResetAll>((event, emit) async {
      DatabaseHelper.resetAllTodosOfSpecificList(id: selectedTodoList!);
      add(SelectedTodolistEventLoadSelectedTodolist(id: selectedTodoList!));
    });
  }
}
