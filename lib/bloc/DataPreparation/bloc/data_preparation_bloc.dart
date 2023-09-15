import 'package:baristodolistapp/bloc/allTodoLists/all_todolists_bloc.dart';
import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/domain/usecases/all_todolists_usecases.dart';
import 'package:baristodolistapp/domain/usecases/data_preparation_usecases.dart';
import 'package:baristodolistapp/models/todolist_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

part 'data_preparation_event.dart';
part 'data_preparation_state.dart';

class DataPreparationBloc
    extends Bloc<DataPreparationEvent, DataPreparationState> {
  final DataPreparationUsecases dataPreparationUsecases;
  final AllTodoListsUsecases allTodoListsUsecases;
  //final AllTodolistsBloc _allTodolistBloc;

  DataPreparationBloc({
    required this.dataPreparationUsecases,
    required this.allTodoListsUsecases,
    // required AllTodolistsBloc allTodolistBloc,
  }) :
        //_allTodolistBloc = allTodolistBloc,
        super(DataPreparationInitial()) {
    // _allTodolistBloc.stream.listen((state) {
    //   if (state is AllTodoListsStateDataPreparationComplete) {
    //     emit(DataPreparationStateDataPreparationComplete());
    //   }
    // });

    // on<DataPreparationEvent>((event, emit) {

    // });

    // on<DataPreparationEventCheckSynchronizationStatus>((event, emit) async {
    //   final failureOrSynchronizationStatus =
    //       await dataPreparationUsecases.checkSynchronizationStatus();
    //   failureOrSynchronizationStatus.fold((l) => null, (r) => null);
    // });

    on<DataPreparationEvent>((event, emit) {});

    on<DataPreparationEventSynchronizeIfNecessary>((event, emit) async {
      final failureOrSynchronizationStatus =
          await dataPreparationUsecases.checkSynchronizationStatus();
      failureOrSynchronizationStatus.fold(
          (l) => emit(DataPreparationStateDataPreparationComplete()), (r) {
        Logger().d('SynchronizationStatus: $r');
        switch (r) {
          case SynchronizationStatus.newUser:
            {
              Logger().d(
                  'SynchronizationStatus.newUser: Emitting DataPreparationStateDataPreparationComplete ');
              emit(DataPreparationStateDataPreparationComplete());
            }
          case SynchronizationStatus.localDataDeleted:
            {
              getIt<AllTodolistsBloc>()
                  .add(AllTodoListEvenGetAllTodoListsFromBackend());
            }
          case SynchronizationStatus.localDateIsNewer:
            {
              emit(DataPreparationStateDataPreparationComplete());
            }
          case SynchronizationStatus.dataIsSynchronized:
            {
              emit(DataPreparationStateDataPreparationComplete());
            }
        }
      });
    });
  }
}
