// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/domain/parameters/delete_file_from_firebase_storage_params.dart';
import 'package:baristodolistapp/domain/parameters/save_photo_to_gallery_params.dart';
import 'package:baristodolistapp/domain/parameters/sync_pending_photo_params.dart';
import 'package:baristodolistapp/domain/repositories/data_preparation_repository.dart';
import 'package:baristodolistapp/domain/repositories/photo_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:baristodolistapp/domain/parameters/upload_to_firebase_storage_parameters.dart';
import 'package:baristodolistapp/domain/repositories/api_repository.dart';

import '../failures/failures.dart';

class PhotoUsecases {
  final ApiRepository apiRepository;
  final DataPreparationRepository dataPreparationRepository;
  final PhotoRepository photoRepository;
  PhotoUsecases({
    required this.apiRepository,
    required this.dataPreparationRepository,
    required this.photoRepository,
  });

  Future<Either<Failure, String>> savePhotoToGalleryUsecase({
    required SavePhotoToGalleryParams savePhotoToGalleryParams,
  }) async {
    return await photoRepository.savePhotoToGallery(
      savePhotoToGalleryParams: savePhotoToGalleryParams,
    );
  }

  Future<Either<Failure, bool>> deletePhotoFromGalleryUsecase({
    required String fullPath,
  }) async {
    return await photoRepository.deletePhotoFromGallery(
      fullPath: fullPath,
    );
  }

  Future<Either<Failure, String>> uploadToFirebaseStorage({
    required UploadToFirebaseStorageParameters
        uploadToFirebaseStorageParameters,
  }) async {
    return await apiRepository.uploadToFirebaseStorage(
      uploadToFirebaseStorageParameters: uploadToFirebaseStorageParameters,
    );
  }

  Future<Either<Failure, bool>> deleteFileFromFirebaseStorage(
      {required DeleteFileFromFirebaseStorageParams
          deleteFileFromFirebaseStorageParams}) async {
    return await apiRepository.deleteFileFromFirebaseStorage(
      deleteFileFromFirebaseStorageParams: deleteFileFromFirebaseStorageParams,
    );
  }

  Future<Either<Failure, int>> addToSyncPendingPhotos(
      {required SyncPendingPhotoParams syncPendingPhotoParams}) async {
    return await dataPreparationRepository.addToSyncPendingPhotos(
      syncPendingPhotoParams: syncPendingPhotoParams,
    );
  }
}
