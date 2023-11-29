import 'package:baristodolistapp/domain/parameters/sync_pending_photo_params.dart';
import 'package:dartz/dartz.dart';

import '../../models/todolist_model.dart';
import '../failures/failures.dart';

abstract class DataPreparationRepository {
  Future<Either<Failure, SynchronizationStatus>> checkSynchronizationStatus();
  Future<Either<Failure, bool>> syncPendingTodoLists();
  Future<Either<Failure, bool>> syncPendingTodos();
  Future<Either<Failure, bool>> syncPendingPhotos();

  Future<Either<Failure, int>> addToSyncPendingPhotos({
    required SyncPendingPhotoParams syncPendingPhotoParams,
  });
}
