import 'package:baristodolistapp/domain/usecases/all_todolists_usecases.dart';
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

    on<AllTodolistsEventDeleteAllTodoLists>(
      (event, emit) async {
        emit(AllTodoListsStateLoading());
        //Try to delete and then get all the lists (there should be)
        //no list left
        await DatabaseHelper.deleteAllTodoLists();
        add(
          AllTodolistsEventGetAllTodoLists(),
        );
      },
    );
    on<AllTodolistsEventCreateNewTodoList>(
      (event, emit) async {
        Either<Failure, int> idOflastCreatedRowOrFailure =
            await allTodoListsUsecases.createNewTodoList(
          todoListEntity: TodoListModel(
            id: null,
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
        List<TodoListModel> listOfTodoListModels =
            await DatabaseHelper.getAllTodoLists();
        if (listOfTodoListModels.isEmpty) {
          emit(AllTodoListsStateListEmpty());
        } else {
          emit(AllTodoListsStateLoaded(listOfAllLists: listOfTodoListModels));
        }
      },
    );

    on<AllTodoListEventUpdateListParameters>((event, emit) async {
      emit(AllTodoListsStateLoading());
      int changesMade = await DatabaseHelper.updateSpecificListParameters(
          id: event.id,
          listName: event.listName,
          category: event.todoListCategory);

      if (changesMade > 0) {
        add(AllTodolistsEventGetAllTodoLists());
      } else {
        emit(AllTodoListsStateError());
      }
    });

    on<AllTodolistsEventDeleteSpecificTodolist>((event, emit) async {
      emit(AllTodoListsStateLoading());
      int changesMade =
          await DatabaseHelper.deleteSpecifiTodoList(id: event.id);
      if (changesMade > 0) {
        add(AllTodolistsEventGetAllTodoLists());
      } else {
        emit(AllTodoListsStateError());
      }
    });
    on<AllTodoListEventCheckRepeatPeriodsAndResetAccomplishedIfNeccessary>(
        (event, emit) async {
      emit(AllTodoListsStateLoading());
      await DatabaseHelper.checkRepeatPeriodsAndResetAccomplishedIfNeccessary();
      add(AllTodolistsEventGetAllTodoLists());
    });
  }
}
