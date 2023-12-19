import '../../../domain/parameters/sync_pending_photo_params.dart';
import '../../../domain/repositories/data_preparation_repository.dart';
import '../../../models/sync_pending_photo_model.dart';
import '../../../services/path_builder.dart';
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
import '../../selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';

part 'data_preparation_event.dart';
part 'data_preparation_state.dart';

class DataPreparationBloc
    extends Bloc<DataPreparationEvent, DataPreparationState> {
  final DataPreparationUsecases dataPreparationUsecases;
  final AllTodoListsUsecases allTodoListsUsecases;
  final SelectedTodolistBloc selectedTodoListBloc;
  final DataPreparationRepository dataPreparationRepository;

  DataPreparationBloc({
    required this.dataPreparationUsecases,
    required this.allTodoListsUsecases,
    required this.selectedTodoListBloc,
    required this.dataPreparationRepository,
  }) : super(DataPreparationInitial()) {
    // on<DataPreparationEvent>((event, emit) {

    // });
    stream.listen((state) {
      Logger().d('State in DatapreparationBloc is $state');
    });

    selectedTodoListBloc.stream.listen((state) {
      if (state is SelectedTodolistStateLoaded && state.synchronize) {
        add(const DataPreparationEventSynchronizeIfNecessary());
      }
    });

    on<DataPreparationEventSynchronizeIfNecessary>((event, emit) async {
      emit(DataPreparationStateLoading());
      final failureOrSynchronizationStatus =
          await dataPreparationUsecases.checkSynchronizationStatus();
      failureOrSynchronizationStatus
          .fold((l) => emit(DataPreparationStateDataPreparationComplete()),
              (r) async {
        switch (r) {
          case SynchronizationStatus.newUser:
            {
              emit(DataPreparationStateDataPreparationComplete());
            }
          case SynchronizationStatus.localDataDeleted:
            {
              getIt<AllTodolistsBloc>()
                  .add(AllTodoListEvenGetAllTodoListsFromBackend());
              final failureOrPhotoUrlModel =
                  await dataPreparationRepository.getPhotoDownloadUrls();
              failureOrPhotoUrlModel.fold(
                  (l) => Logger().e('failureOrPhotoUrlModel is left $l'), (r) {
                for (var model in r.downloadableImages) {
                  final imageName =
                      PathBuilder.photoNameExtractor(model.imagePath);
                  dataPreparationRepository.addToSyncPendingPhotos(
                      syncPendingPhotoParams: SyncPendingPhotoParams(
                          photoName: imageName,
                          method: SyncPendingPhotoMethod.download,
                          downloadUrl: model.downLoadUrl));
                }
                add(DataPreparationEventSyncAllSyncPendingLists());
              });
            }
          case SynchronizationStatus.localDataIsNewer:
            {
              add(DataPreparationEventSyncAllSyncPendingLists());
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

    on<DataPreparationEventSyncAllSyncPendingLists>((event, emit) async {
      emit(DataPreparationStateLoading());
      Either<Failure, bool> success =
          await dataPreparationUsecases.syncPendingTodoLists();

      success.fold((l) => emit(DataPreparationStateUploadFailed()), (r) {});

      Either<Failure, bool> todosUploaded =
          await dataPreparationUsecases.syncPendingTodos();

      todosUploaded.fold(
          (l) => emit(DataPreparationStateUploadFailed()), (r) {});

      Either<Failure, bool> photosSynced =
          await dataPreparationUsecases.syncPendingPhotos();
      photosSynced.fold((l) => null, (r) {});
    });
  }
}
