import 'package:dartz/dartz.dart';

import '../../models/todolist_model.dart';
import '../failures/failures.dart';

abstract class DataPreparationRepository {
  Future<Either<Failure, SynchronizationStatus>> checkSynchronizationStatus();
  Future<Either<Failure, bool>> uploadSyncPendingTodoLists();
}
