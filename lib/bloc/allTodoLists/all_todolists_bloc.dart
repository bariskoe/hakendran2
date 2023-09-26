import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../database/databse_helper.dart';
import '../../dependency_injection.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/connectivity_repository.dart';
import '../../domain/usecases/all_todolists_usecases.dart';
import '../../domain/usecases/api_usecases.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todolist_model.dart';
import '../../pages/main_page.dart';
import '../DataPreparation/bloc/data_preparation_bloc.dart';
import '../selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';

part 'all_todolists_event.dart';
part 'all_todolists_state.dart';

class AllTodolistsBloc extends Bloc<AllTodolistsEvent, AllTodolistsState> {
  final SelectedTodolistBloc _selectedTodolistBloc;
  final ConnectivityRepository connectivityRepository;
  final AllTodoListsUsecases allTodoListsUsecases;
  final ApiUsecases apiUsecases;

  AllTodolistsBloc({
    required SelectedTodolistBloc selectedTodolistBloc,
    required this.connectivityRepository,
    required this.allTodoListsUsecases,
    required this.apiUsecases,
  })  : _selectedTodolistBloc = selectedTodolistBloc,
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
        emit(AllTodoListsStateLoading());
        var uuidLibrary = const Uuid();
        String uid = uuidLibrary.v1();
        Logger().d('uid on create in bloc is $uid');

        // This id is not the uid of the created TodoList
        Either<Failure, int> idOflastCreatedRowOrFailure =
            await allTodoListsUsecases.createNewTodoList(
          todoListEntity: TodoListModel(
            todoModels: const [],
            listName: event.listName,
            todoListCategory: event.todoListCategory,
            uid: uid,
          ),
        );

        idOflastCreatedRowOrFailure.fold((l) {
          emit(AllTodoListsStateError());
        }, (r) {
          MainPage.justAddedList = true;
          DatabaseHelper.addTodoListUidToSyncPendingTodoLists(uid: uid);
          add(AllTodolistsEventGetAllTodoLists());
          getIt<DataPreparationBloc>()
              .add(const DataPreparationEventSynchronizeIfNecessary());
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

    // on<AllTodolistsEventSynchronizeAllTodoListsWithBackend>(
    //     (event, emit) async {
    //   emit(AllTodoListsStateSynchronizingWithBackend());

    //   Either<Failure, List<TodoListModel>> failureOrListOfTodoListModels =
    //       await allTodoListsUsecases.getAllTodoLists();

    //   //! Emit an error state if Failure is returned
    //   await failureOrListOfTodoListModels.fold((l) => null, (todolists) async {
    //     if (todolists.isEmpty) {
    //       emit(AllTodoListsStateListEmpty());
    //     } else {
    //       Either<Failure, bool> uploadToBackendSuccessful =
    //           await allTodoListsUsecases
    //               .synchronizeAllTodoListsWithBackend(todolists);
    //       uploadToBackendSuccessful.fold((l) {
    //         emit(AllTodoListsStateError());
    //       }, (r) {
    //         emit(AllTodoListsStateLoaded(listOfAllLists: todolists));
    //       });
    //     }
    //   });
    // });

    _allTodoListEvenGetAllTodoListsFromBackend(event, emit) async {
      Logger().d('AllTodoListEvenGetAllTodoListsFromBackend received');
      emit(AllTodoListsStateLoading());

      Either<Failure, Map<String, dynamic>?> data =
          await allTodoListsUsecases.getAllTodoListsFromBackend();
      data.fold((l) {
        Logger()
            .d('Failure in allTodoListsUsecases.getAllTodoListsFromBackend');
        emit(AllTodoListsStateListEmpty());
      }, (r) async {
        Logger().i('lists: $r');

        final List todolists = r?['todoLists'];
        // todolists.sort((a, b) => a['id'].compareTo(b['id']));
        Logger().d('todolists vom Backend sind: $todolists');

        Future<void> saveListOfTodolistsLocally(List<dynamic> todoLists) async {
          Future.wait(todolists.map((todoList) async =>
              await allTodoListsUsecases.createNewTodoList(
                  todoListEntity: TodoListModel(
                      uid: todoList['uid'],
                      listName: todoList['listName'],
                      todoListCategory: TodoListCategoryExtension.deserialize(
                          todoList['category']),
                      todoModels: []))));
        }

        await saveListOfTodolistsLocally(todolists);
      });
    }

    on<AllTodoListEvenGetAllTodoListsFromBackend>((event, emit) async {
      await _allTodoListEvenGetAllTodoListsFromBackend(event, emit)
          .whenComplete(() {
        Logger().d('emitting AllTodoListsStateDataPreparationComplete');

        emit(AllTodoListsStateDataPreparationComplete());
      });
    });

    on<AllTodoListEventUpdateListParameters>((event, emit) async {
      emit(AllTodoListsStateLoading());

      Either<Failure, int> failureOrChanges =
          await allTodoListsUsecases.updateSpecificListParameters(
              todoListUpdateModel: TodoListUpdateModel(
        uid: event.uid,
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
      Either<Failure, int> failureOrChangesMade =
          await allTodoListsUsecases.deleteSpecifiTodoList(uid: event.uid);

      failureOrChangesMade.fold(
          (l) => emit(AllTodoListsStateError()), (r) => null);
    });

    on<AllTodoListEventCheckRepeatPeriodsAndResetAccomplishedIfNeccessary>(
        (event, emit) async {
      emit(AllTodoListsStateLoading());

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

        Either<Failure, int> failureOrSuccess =
            await allTodoListsUsecases.deleteAllTodoLists();
        failureOrSuccess.fold((l) => emit(AllTodoListsStateError()),
            (r) => add(AllTodolistsEventGetAllTodoLists()));
      },
    );
  }
}
