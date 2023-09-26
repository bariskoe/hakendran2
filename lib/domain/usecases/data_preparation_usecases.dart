import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../models/todolist_model.dart';
import '../failures/failures.dart';
import '../repositories/data_preparation_repository.dart';

class DataPreparationUsecases {
  final DataPreparationRepository dataPreparationRepository;
  DataPreparationUsecases({
    required this.dataPreparationRepository,
  });

  Future<Either<Failure, SynchronizationStatus>>
      checkSynchronizationStatus() async {
    final result = await dataPreparationRepository.checkSynchronizationStatus();
    Logger().d('Synchronizationstatus im usecase ist $result');
    return result;
  }

  Future<Either<Failure, bool>> uploadSyncPendingTodoLists() async {
    final result = await dataPreparationRepository.uploadSyncPendingTodoLists();

    return result;
  }

  Future<Either<Failure, bool>> uploadSyncPendingTodos() async {
    final result = await dataPreparationRepository.uploadSyncPendingTodos();
    return result;
  }
}
