// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:baristodolistapp/domain/parameters/save_photo_to_gallery_params.dart';
import 'package:baristodolistapp/domain/repositories/photo_repository.dart';
import 'package:baristodolistapp/services/path_builder.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../dependency_injection.dart';
import '../../strings/string_constants.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PathBuilder pathBuilder;
  PhotoRepositoryImpl({
    required this.pathBuilder,
  });

  @override
  Future<Either<Failure, String>> savePhotoToGallery(
      {required SavePhotoToGalleryParams savePhotoToGalleryParams}) async {
    try {
      const uuid = Uuid();
      final photoUid = uuid.v1();

      final userId = getIt<SharedPreferences>()
          .getString(StringConstants.spFirebaseUserIDKey);

      if (userId == null) {
        return Left(SavePhotoFailure(
            message:
                'No userID available in SharedPreferences. Can not save photo to gallery.'));
      } else {
        final folderPath = pathBuilder.pathToLocalPhotoFolder;
        final completeFilepath = '$folderPath/$photoUid';

        await savePhotoToGalleryParams.xfile.saveTo(completeFilepath);
        return Right(photoUid);
      }
    } catch (e) {
      Logger().e('$e');
      return Left(SavePhotoFailure(
          message: 'Error during photo saving: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePhotoFromGallery(
      {required String fullPath}) async {
    try {
      final fileTodelete = File(fullPath);
      final deleted = await fileTodelete.delete();
      Logger().d('Deleted FileEntity: $deleted');
      return const Right(true);
    } catch (e) {
      Logger().e('$e');
      return Left(SavePhotoFailure(
          message: 'Error during photo deletion: ${e.toString()}'));
    }
  }
}
