// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'photo_bloc.dart';

sealed class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class PhotoEventSaveTodoThumbnailPhotoToGallery extends PhotoEvent {
  final SavePhotoToGalleryParams savePhotoToGalleryParams;

  const PhotoEventSaveTodoThumbnailPhotoToGallery({
    required this.savePhotoToGalleryParams,
  });

  @override
  List<Object> get props => [
        savePhotoToGalleryParams,
      ];
}

class PhotoEventTakePicture extends PhotoEvent {}

class PhotoEventAddToSyncPendingPhotos extends PhotoEvent {
  final SyncPendingPhotoParams syncPendingPhotoParams;

  const PhotoEventAddToSyncPendingPhotos({
    required this.syncPendingPhotoParams,
  });
}

class PhotoEventTakeThumbnailPicture extends PhotoEvent {
  final TakeThumbnailPhotoParams takeThumbnailPhotoParams;
  const PhotoEventTakeThumbnailPicture({
    required this.takeThumbnailPhotoParams,
  });
}

class PhotoEventSetSelectedThumbnailPhoto extends PhotoEvent {
  final String fullImagePath;
  const PhotoEventSetSelectedThumbnailPhoto({
    required this.fullImagePath,
  });
}

class PhotoEventDeleteThumbnailPhotoFromGallery extends PhotoEvent {}
