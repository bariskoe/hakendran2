import '../parameters/save_photo_to_gallery_params.dart';
import 'package:dartz/dartz.dart';

import '../failures/failures.dart';

abstract class PhotoRepository {
  Future<Either<Failure, String>> savePhotoToGallery({
    required SavePhotoToGalleryParams savePhotoToGalleryParams,
  });
  Future<Either<Failure, bool>> deletePhotoFromGallery({
    required String fullPath,
  });
}
