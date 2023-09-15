import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dependency_injection.dart';
import '../../domain/repositories/data_preparation_repository.dart';
import '../../models/todo_list_update_model.dart';
import '../../models/todolist_model.dart';

import '../../domain/entities/todolist_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/all_todolists_repository.dart';
import '../datasources/local_sqlite_datasource.dart';
import 'package:dartz/dartz.dart';

class DataPreparationRepositoryImpl implements DataPreparationRepository {
  final LocalSqliteDataSource localSqliteDataSource;
  final ApiDatasource apiDatasource;

  DataPreparationRepositoryImpl({
    required this.localSqliteDataSource,
    required this.apiDatasource,
  });

  @override
  Future<Either<Failure, SynchronizationStatus>>
      checkSynchronizationStatus() async {
    try {
      final Map<String, dynamic>? data = await apiDatasource.getDataInfo();
      Logger().d('data is $data');
      if (data == null) {
        return const Right(SynchronizationStatus.newUser);
      }
      if (data[StringConstants.spDBTimestamp] != null &&
          data[StringConstants.firestoreFieldNumberOfLists] != null) {
        final localTimestamp =
            getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
        if (localTimestamp == null) {
          return const Right(SynchronizationStatus.localDataDeleted);
        } else if (localTimestamp == data[StringConstants.spDBTimestamp]) {
          return const Right(SynchronizationStatus.dataIsSynchronized);
        } else if (localTimestamp > data[StringConstants.spDBTimestamp]) {
          return const Right(SynchronizationStatus.localDateIsNewer);
        }
      } else {
        Logger()
            .d('returning api failure because fs timestamp or lists is null');
        return Left(ApiFailure());
      }
    } catch (e) {
      Logger().d('returning api failure due to error');
      return Left(ApiFailure());
    }
    Logger().d('returning api failure as default');
    return Left(ApiFailure());
  }
}
