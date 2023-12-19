import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../dependency_injection.dart';
import '../../../domain/entities/todolist_entity.dart';
import '../../../domain/failures/failures.dart';
import '../../../domain/parameters/todo_parameters.dart';
import '../../../domain/parameters/todo_update_parameters.dart';
import '../../../domain/parameters/update_todo_parameters.dart';
import '../../../domain/usecases/selected_todolist_usecases.dart';
import '../../../models/todo_model.dart';
import '../../../pages/todo_detail_page.dart';
import '../../DataPreparation/bloc/data_preparation_bloc.dart';

part 'selected_todolist_event.dart';
part 'selected_todolist_state.dart';

class SelectedTodolistBloc
    extends Bloc<SelectedTodolistEvent, SelectedTodolistState> {
  static String? selectedTodoList;

  SelectedTodolistUsecases selectedTodolistUsecases;
  SelectedTodolistBloc({required this.selectedTodolistUsecases})
      : super(SelectedTodolistInitial()) {
    /*
    on<>((event, emit) async {
    
      });
    */

    on<SelectedTodolistEventLoadSelectedTodolist>((event, emit) async {
      emit(SelectedTodoListStateLoading());
      Either<Failure, TodoListEntity> todoListEntity =
          await selectedTodolistUsecases.getSpecificTodoList(uid: event.uid);
      todoListEntity.fold((l) => emit(SelectedTodolistStateError()), (r) {
        emit(
          SelectedTodolistStateLoaded(
              todoListEntity: r, synchronize: event.synchronize),
        );
        Logger().d('selected TodoList: ${r.toString()}');
      });
      Logger().d('selected list loaded');
    });

    on<SelectedTodolistEventAddNewTodo>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      const uuidPackage = Uuid();
      final uid = uuidPackage.v1();

      if (selectedTodoList != null) {
        TodoListDetailPage.justAddedTodo = true;

        Either<Failure, int> didSave = await selectedTodolistUsecases
            .addTodoToSpecificList(todoModel: event.todoModel);
        didSave.fold((l) => emit(SelectedTodolistStateError()), (r) {
          add(SelectedTodoListEventAddTodoUidToSyncPendingTodos(
              todoParameters: TodoParameters(
                  parentTodoListId: event.todoModel.parentTodoListId,
                  uid: event.todoModel.uid)));
          add(SelectedTodolistEventLoadSelectedTodolist(
              uid: selectedTodoList!));
        });
      }
    });

    on<SelectedTodolistEventUnselect>((event, emit) async {
      selectedTodoList = null;
    });

    on<SelectedTodoListEventSelectSpecificTodoList>((event, emit) async {
      selectedTodoList = event.uid;
      Logger().d('Selected todolist uid: $selectedTodoList');
    });

    on<SelectedTodolistEventUpdateAccomplishedOfTodo>(
      (event, emit) async {
        emit(SelectedTodoListStateLoading());
        Either<Failure, int> changes =
            await selectedTodolistUsecases.setAccomplishmentStatusOfTodo(
                uid: event.uid, accomplished: event.accomplished);
        changes.fold((l) => emit(SelectedTodolistStateError()), (r) {
          add(SelectedTodoListEventAddTodoUidToSyncPendingTodos(
              todoParameters: TodoParameters(
            parentTodoListId: selectedTodoList!,
            uid: event.uid,
            task: '',
            accomplished: event.accomplished,
          )));
          add(
            SelectedTodolistEventLoadSelectedTodolist(uid: selectedTodoList!),
          );
        });
      },
    );

    on<SelectedTodoListEventUpdateTodo>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      Either<Failure, int> changes = await selectedTodolistUsecases
          .updateSpecificTodo(todoUpdateParameters: event.todoUpdateParameters);
      Logger().d('changes sind $changes');
      changes.fold((l) => emit(SelectedTodolistStateError()), (r) {
        getIt<SelectedTodolistBloc>().add(
            SelectedTodoListEventAddTodoUidToSyncPendingTodos(
                todoParameters:
                    TodoParameters(uid: event.todoUpdateParameters.uid)));
        add(
          SelectedTodolistEventLoadSelectedTodolist(uid: selectedTodoList!),
        );
      });
    });

    on<SelectedTodolistEventDeleteSpecificTodo>((event, emit) async {
      Either<Failure, int> changes = await selectedTodolistUsecases
          .deleteSpecificTodo(todoParameters: event.todoParameters);

      changes.fold((l) => emit(SelectedTodolistStateError()), (r) {
        add(SelectedTodoListEventAddTodoUidToSyncPendingTodos(
            todoParameters: event.todoParameters));
      });
//No need to reload the list here. The Dismissible Listview takes care of the ui.
    });

    on<SelectedTodoListEventResetAll>((event, emit) async {
      emit(SelectedTodoListStateLoading());

      Either<Failure, int> failureOrChanges = await selectedTodolistUsecases
          .resetAllTodosOfSpecificList(uid: selectedTodoList!);

      failureOrChanges.fold(
        (l) => emit(SelectedTodolistStateError()),
        (r) => add(
          SelectedTodolistEventLoadSelectedTodolist(uid: selectedTodoList!),
        ),
      );
    });

    on<SelectedTodoListEventAddTodoListUidToSyncPendingTodoLists>(
        (event, emit) async {
      Either<Failure, int> failureOridOfInsertedRow =
          await selectedTodolistUsecases.addTodoListUidToSyncPendingTodoLists(
        uid: event.uid,
      );

      failureOridOfInsertedRow.fold((l) => null, (r) {
        getIt<DataPreparationBloc>()
            .add(const DataPreparationEventSynchronizeIfNecessary());
      });
    });

    on<SelectedTodoListEventAddTodoUidToSyncPendingTodos>((event, emit) async {
      Either<Failure, int> failureOridOfInsertedRow =
          await selectedTodolistUsecases.addTodoUidToSyncPendingTodos(
        todoParameters: event.todoParameters,
      );
      failureOridOfInsertedRow.fold((l) => null, (r) {
        getIt<DataPreparationBloc>()
            .add(const DataPreparationEventSynchronizeIfNecessary());
      });
    });
  }
}
