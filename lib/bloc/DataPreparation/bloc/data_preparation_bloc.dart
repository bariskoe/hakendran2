import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../dependency_injection.dart';
import '../../../domain/failures/failures.dart';
import '../../../domain/usecases/all_todolists_usecases.dart';
import '../../../domain/usecases/data_preparation_usecases.dart';
import '../../../models/todolist_model.dart';
import '../../allTodoLists/all_todolists_bloc.dart';

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

    on<DataPreparationEventSynchronizeIfNecessary>((event, emit) async {
      emit(DataPreparationStateLoading());
      final failureOrSynchronizationStatus =
          await dataPreparationUsecases.checkSynchronizationStatus();
      failureOrSynchronizationStatus.fold(
          (l) => emit(DataPreparationStateDataPreparationComplete()), (r) {
        Logger().d('SynchronizationStatus: $r');
        switch (r) {
          case SynchronizationStatus.newUser:
            {
              emit(DataPreparationStateDataPreparationComplete());
            }
          case SynchronizationStatus.localDataDeleted:
            {
              getIt<AllTodolistsBloc>()
                  .add(AllTodoListEvenGetAllTodoListsFromBackend());
            }
          case SynchronizationStatus.localDataIsNewer:
            {
              add(DataPreparationEventUploadSyncPendingTodoLists());
            }
          case SynchronizationStatus.dataIsSynchronized:
            {
              emit(DataPreparationStateDataPreparationComplete());
            }
          case SynchronizationStatus.unknown:
            {
              emit(DataPreparationStateDataPreparationComplete());
            }
        }
      });
    });

    on<DataPreparationEventUploadSyncPendingTodoLists>((event, emit) async {
      emit(DataPreparationStateLoading());
      Either<Failure, bool> success =
          await dataPreparationUsecases.uploadSyncPendingTodoLists();

      success.fold((l) => emit(DataPreparationStateUploadFailed()),
          (r) => emit(DataPreparationStateDataPreparationComplete()));
    });
  }
}
