import 'package:baristodolistapp/database/databse_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dependency_injection.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/data_preparation_repository.dart';
import '../../models/todolist_model.dart';
import '../../strings/string_constants.dart';
import '../datasources/api_datasource.dart';
import '../datasources/local_sqlite_datasource.dart';

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
      final Map<String, dynamic>? remoteData =
          await apiDatasource.getDataInfo();
      Logger().d('dataInfo is $remoteData');
      final syncPendingTodoLists =
          await DatabaseHelper.getAllEntriesOfsyncPendigTodolists();
      final syncPendingTodos =
          await DatabaseHelper.getAllEntriesOfsyncPendigTodos();
      Logger().d('syncPendingTodoLists = $syncPendingTodoLists');
      Logger().d('syncPendingTodos = $syncPendingTodos');
      final hasSyncPending = syncPendingTodoLists['numberOfEntries'] +
                  syncPendingTodos['numberOfEntries'] >
              0
          ? true
          : false;
      Logger().d('hasSyncPending = $hasSyncPending');

      if (remoteData == null && !hasSyncPending) {
        return const Right(SynchronizationStatus.newUser);
      }
      if (remoteData?[StringConstants.spDBTimestamp] == null &&
          !hasSyncPending) {
        return const Right(SynchronizationStatus.newUser);
      }
      if (remoteData?[StringConstants.spDBTimestamp] == null &&
          hasSyncPending) {
        return const Right(SynchronizationStatus.localDataIsNewer);
      }

      if (remoteData?[StringConstants.spDBTimestamp] != null &&
          remoteData?[StringConstants.firestoreFieldNumberOfLists] != null) {
        final localTimestamp =
            getIt<SharedPreferences>().getInt(StringConstants.spDBTimestamp);
        if (localTimestamp == null) {
          return const Right(SynchronizationStatus.localDataDeleted);
        } else {
          if (hasSyncPending) {
            return const Right(SynchronizationStatus.localDataIsNewer);
          }
          if (!hasSyncPending) {
            return const Right(SynchronizationStatus.dataIsSynchronized);
          }
        }
      }
      if (remoteData?[StringConstants.spDBTimestamp] != null &&
          remoteData?[StringConstants.firestoreFieldNumberOfLists] == null) {
        if (hasSyncPending) {
          return const Right(SynchronizationStatus.localDataIsNewer);
        }
        if (!hasSyncPending) {
          return const Right(SynchronizationStatus.dataIsSynchronized);
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

  @override
  Future<Either<Failure, bool>> uploadSyncPendingTodoLists() async {
    try {
      final success = await apiDatasource.uploadSyncPendingTodoLists();
      return Right(success);
    } catch (e) {
      return Left(ApiFailure());
    }
  }
}
