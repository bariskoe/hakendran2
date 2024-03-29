import '../../domain/parameters/sync_pending_photo_params.dart';
import '../../models/downloadable_photos_model.dart';

import '../../database/databse_helper.dart';
import '../../models/firestore_data_info_model.dart';
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
    // TODO: Hier aufräumen
    try {
      final FirestoreDataInfoModel? remoteData =
          await apiDatasource.getDataInfo();
      // Logger().d('dataInfo is ${remoteData?["dataInfo"]}');
      final syncPendingTodoLists =
          await DatabaseHelper.getAllEntriesOfsyncPendigTodolists();
      final syncPendingTodos =
          await DatabaseHelper.getAllEntriesOfsyncPendigTodos();
      final syncPendingPhotosHasEntries =
          await DatabaseHelper.hasEntries(DatabaseHelper.syncPendingPhotosName);
      final syncPendingPhotosEntries = syncPendingPhotosHasEntries ? 1 : 0;

      final hasSyncPending = syncPendingTodoLists['numberOfEntries'] +
                  syncPendingTodos['numberOfEntries'] +
                  syncPendingPhotosEntries >
              0
          ? true
          : false;
      Logger().d('hasSyncPending = $hasSyncPending');

      if (remoteData == null) {
        Logger().d('remodata = null');
        return const Right(SynchronizationStatus.unknown);
      } else {
        final FirestoreDataInfoModel firestoreDataInfoModel = remoteData;
        if (firestoreDataInfoModel.dataIsAcessible == false) {
          return const Right(SynchronizationStatus.unknown);
        }

        if (firestoreDataInfoModel.userDocExists == false && !hasSyncPending) {
          Logger().d(
              'firestoreDataInfoModel.userDocExists != true && !hasSyncPending');
          return const Right(SynchronizationStatus.newUser);
        }

        if (firestoreDataInfoModel.timestamp == null && !hasSyncPending) {
          Logger()
              .d('firestoreDataInfoModel.timestamp == null && !hasSyncPending');
          return const Right(SynchronizationStatus.newUser);
        }
        if (firestoreDataInfoModel.dataIsAcessible != false &&
            firestoreDataInfoModel.timestamp == null &&
            hasSyncPending) {
          return const Right(SynchronizationStatus.localDataIsNewer);
        }

        if (firestoreDataInfoModel.timestamp != null &&
            firestoreDataInfoModel.count != null) {
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
        if (firestoreDataInfoModel.timestamp != null &&
            firestoreDataInfoModel.count == null) {
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
      }
    } catch (e) {
      Logger().d('returning api failure due to error: $e');
      return Left(ApiFailure());
    }
    Logger().d('returning api failure as default');
    return Left(ApiFailure());
  }

  @override
  Future<Either<Failure, bool>> syncPendingTodoLists() async {
    try {
      final success = await apiDatasource.syncPendingTodoLists();
      return Right(success);
    } catch (e) {
      Logger().e('Could not sync pending todoLists: $e');
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> syncPendingTodos() async {
    try {
      final success = await apiDatasource.syncPendingTodos();
      return Right(success);
    } catch (e) {
      Logger().e('Could not sync pending todos: $e');
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addToSyncPendingPhotos(
      {required SyncPendingPhotoParams syncPendingPhotoParams}) async {
    try {
      final success = await localSqliteDataSource.addToSyncPendingPhotos(
          syncPendingPhotoParams: syncPendingPhotoParams);
      Logger().d('success ist $success');
      if (success != 0) {
        return Right(success);
      } else {
        return Left(DatabaseFailure());
      }
    } catch (e) {
      Logger().e('Could not add to sync pending photos: $e');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> syncPendingPhotos() async {
    try {
      final success = await apiDatasource.syncPendingPhotos();
      return Right(success);
    } catch (e) {
      Logger().e('Could not sync pending photos: $e');
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, PhotoDownloadUrlsModel>> getPhotoDownloadUrls() async {
    try {
      final model = await apiDatasource.getPhotoDownloadUrls();
      if (model == null) {
        return Left(ApiFailure());
      } else {
        return Right(model);
      }
    } catch (e) {
      Logger().e('Could not get PhotoDownloadUrls $e');
      return Left(ApiFailure());
    }
  }
}
