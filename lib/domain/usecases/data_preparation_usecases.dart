import 'package:logger/logger.dart';

import '../../models/todo_list_update_model.dart';

import '../../models/todolist_model.dart';
import '../entities/todolist_entity.dart';
import 'package:dartz/dartz.dart';

import '../failures/failures.dart';
import '../repositories/all_todolists_repository.dart';
import '../repositories/data_preparation_repository.dart';

class DataPreparationUsecases {
  final DataPreparationRepository dataPreparationRepository;
  DataPreparationUsecases({required this.dataPreparationRepository});

  Future<Either<Failure, SynchronizationStatus>>
      checkSynchronizationStatus() async {
    final result = await dataPreparationRepository.checkSynchronizationStatus();
    Logger().d('Synchronizationstatus im usecase ist $result');
    return result;
  }
}
