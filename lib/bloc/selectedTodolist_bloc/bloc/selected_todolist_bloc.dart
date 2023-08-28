import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../database/databse_helper.dart';
import '../../../domain/entities/todolist_entity.dart';
import '../../../domain/failures/failures.dart';
import '../../../domain/usecases/selected_todolist_usecases.dart';
import '../../../models/todo_model.dart';
import '../../../models/todolist_model.dart';
import '../../../pages/todo_detail_page.dart';

part 'selected_todolist_event.dart';
part 'selected_todolist_state.dart';

class SelectedTodolistBloc
    extends Bloc<SelectedTodolistEvent, SelectedTodolistState> {
  String? selectedTodoList;
  SelectedTodolistUsecases selectedTodolistUsecases;
  SelectedTodolistBloc({required this.selectedTodolistUsecases})
      : super(SelectedTodolistInitial()) {
    /*
    on<>((event, emit) async {
    
      });
    */
    on<SelectedTodolistEvent>((event, emit) async {});

    on<SelectedTodolistEventLoadSelectedTodolist>((event, emit) async {
      emit(SelectedTodoListStateLoading());
      Either<Failure, TodoListEntity> model =
          await selectedTodolistUsecases.getSpecificTodoList(uuid: event.uuid);
      model.fold((l) => emit(SelectedTodolistStateError()), (r) {
        emit(
          SelectedTodolistStateLoaded(
            todoListModel: r.toModel(),
          ),
        );
        Logger().d(r.toModel().toString());
      });
      Logger().d('selected list loaded');
    });

    on<SelectedTodolistEventAddNewTodo>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      TodoModel adjustbleTodoModel;
      if (selectedTodoList != null) {
        final eventModel = event.todoModel;
        adjustbleTodoModel = TodoModel(
            id: eventModel.id,
            task: eventModel.task,
            accomplished: eventModel.accomplished,
            parentTodoListId: selectedTodoList!);
        TodoListDetailPage.justAddedTodo = true;

        Either<Failure, int> didSave = await selectedTodolistUsecases
            .addTodoToSpecificList(todoModel: adjustbleTodoModel);
        didSave.fold(
            (l) => emit(SelectedTodolistStateError()),
            (r) => add(SelectedTodolistEventLoadSelectedTodolist(
                uuid: selectedTodoList!)));
      }
    });

    on<SelectedTodolistEventUnselect>((event, emit) async {
      selectedTodoList = null;
    });

    on<SelectedTodoListEventSelectSpecificTodoList>((event, emit) async {
      selectedTodoList = event.uuid;
    });

    on<SelectedTodolistEventUpdateAccomplishedOfTodo>(
      (event, emit) async {
        Either<Failure, int> changes =
            await selectedTodolistUsecases.setAccomplishmentStatusOfTodo(
                uuid: event.uuid, accomplished: event.accomplished);
        changes.fold(
          (l) => emit(SelectedTodolistStateError()),
          (r) => add(
            SelectedTodolistEventLoadSelectedTodolist(uuid: selectedTodoList!),
          ),
        );
      },
    );

    on<SelectedTodolistEventUpdateTodo>((event, emit) async {
      emit(SelectedTodoListStateLoading());
      Either<Failure, int> changes = await selectedTodolistUsecases
          .updateSpecificTodo(todoModel: event.todoModel);
      Logger().d('changes sind $changes');
      changes.fold(
        (l) => emit(SelectedTodolistStateError()),
        (r) => add(
          SelectedTodolistEventLoadSelectedTodolist(uuid: selectedTodoList!),
        ),
      );
    });

    on<SelectedTodolistEventDeleteSpecificTodo>((event, emit) async {
      await DatabaseHelper.deleteSpecificTodo(uuid: event.uuid);
//No need to reload the list here. The Dismissible Listview takes care of the ui.
    });

    on<SelectedTodoListEventResetAll>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      Either<Failure, int> failureOrChanges = await selectedTodolistUsecases
          .resetAllTodosOfSpecificList(uuid: selectedTodoList!);

      failureOrChanges.fold(
        (l) => emit(SelectedTodolistStateError()),
        (r) => add(
          SelectedTodolistEventLoadSelectedTodolist(uuid: selectedTodoList!),
        ),
      );
    });
  }
}
