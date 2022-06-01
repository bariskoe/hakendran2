import '../../models/todo_list_update_model.dart';

import '../../domain/usecases/all_todolists_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../database/databse_helper.dart';
import '../../domain/failures/failures.dart';
import '../../models/todolist_model.dart';
import '../../pages/main_page.dart';
import '../selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';

part 'all_todolists_event.dart';
part 'all_todolists_state.dart';

class AllTodolistsBloc extends Bloc<AllTodolistsEvent, AllTodolistsState> {
  final SelectedTodolistBloc _selectedTodolistBloc;

  final AllTodoListsUsecases allTodoListsUsecases;

  AllTodolistsBloc(
      {required SelectedTodolistBloc selectedTodolistBloc,
      required this.allTodoListsUsecases})
      : _selectedTodolistBloc = selectedTodolistBloc,
        super(AllTodolistsInitial()) {
    _selectedTodolistBloc.stream.listen((state) {
      if (state is SelectedTodolistStateLoaded) {
        add(AllTodolistsEventGetAllTodoLists());
      }
    });

    /*
    on<>((event, emit) async {
    
      });
    */

    on<AllTodolistsEventCreateNewTodoList>(
      (event, emit) async {
        Either<Failure, int> idOflastCreatedRowOrFailure =
            await allTodoListsUsecases.createNewTodoList(
          todoListEntity: TodoListModel(
            todoModels: const [],
            listName: event.listName,
            todoListCategory: event.todoListCategory,
          ),
        );

        idOflastCreatedRowOrFailure.fold((l) {
          emit(AllTodoListsStateError());
        }, (r) {
          MainPage.justAddedList = true;
          add(AllTodolistsEventGetAllTodoLists());
        });
      },
    );
    on<AllTodolistsEventGetAllTodoLists>(
      (event, emit) async {
        emit(AllTodoListsStateLoading());

        Either<Failure, List<TodoListModel>> failureOrListOfTodoListModels =
            await allTodoListsUsecases.getAllTodoLists();

        failureOrListOfTodoListModels.fold((l) => null, (r) {
          if (r.isEmpty) {
            emit(AllTodoListsStateListEmpty());
          } else {
            emit(AllTodoListsStateLoaded(listOfAllLists: r));
          }
        });
      },
    );

    on<AllTodoListEventUpdateListParameters>((event, emit) async {
      emit(AllTodoListsStateLoading());

      Either<Failure, int> failureOrChanges =
          await allTodoListsUsecases.updateSpecificListParameters(
              todoListUpdateModel: TodoListUpdateModel(
        id: event.id,
        listName: event.listName,
        todoListCategory: event.todoListCategory,
      ));

      failureOrChanges.fold((l) => emit(AllTodoListsStateError()), (r) {
        if (r > 0) {
          add(AllTodolistsEventGetAllTodoLists());
        } else {
          emit(AllTodoListsStateError());
        }
      });
    });

    on<AllTodolistsEventDeleteSpecificTodolist>((event, emit) async {
      //emit(AllTodoListsStateLoading());

      Either<Failure, int> failureOrChangesMade =
          await allTodoListsUsecases.deleteSpecifiTodoList(id: event.id);

      failureOrChangesMade.fold(
          (l) => emit(AllTodoListsStateError()), (r) => null);
    });

    on<AllTodoListEventCheckRepeatPeriodsAndResetAccomplishedIfNeccessary>(
        (event, emit) async {
      emit(AllTodoListsStateLoading());
      //await DatabaseHelper.checkRepeatPeriodsAndResetAccomplishedIfNeccessary();
      Either<Failure, bool> failureOrchecked = await allTodoListsUsecases
          .checkRepeatPeriodsAndResetAccomplishedIfNeccessary();
      failureOrchecked.fold((l) => emit(AllTodoListsStateError()), (r) => null);

      add(AllTodolistsEventGetAllTodoLists());
    });

    on<AllTodolistsEventDeleteAllTodoLists>(
      (event, emit) async {
        emit(AllTodoListsStateLoading());
        //Try to delete and then get all the lists (there should be)
        //no list left

        //  await DatabaseHelper.deleteAllTodoLists();
        Either<Failure, int> failureOrSuccess =
            await allTodoListsUsecases.deleteAllTodoLists();
        failureOrSuccess.fold((l) => emit(AllTodoListsStateError()),
            (r) => add(AllTodolistsEventGetAllTodoLists()));
      },
    );
  }
}
