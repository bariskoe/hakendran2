// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:baristodolistapp/domain/parameters/save_photo_to_gallery_params.dart';
import 'package:baristodolistapp/domain/parameters/sync_pending_photo_params.dart';
import 'package:baristodolistapp/domain/parameters/take_thumbnail_photo_params.dart';
import 'package:baristodolistapp/domain/parameters/todo_update_parameters.dart';
import 'package:baristodolistapp/domain/usecases/photo_usecases.dart';
import 'package:baristodolistapp/models/sync_pending_photo_model.dart';
import 'package:baristodolistapp/services/image_picker_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../dependency_injection.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoUsecases photoUsecases;
  PhotoBloc({
    required this.photoUsecases,
  }) : super(PhotoInitial()) {
    // on<PhotoEvent>((event, emit) {

    // });
    String? _selectedThumbnailPhoto;

    on<PhotoEventTakeThumbnailPicture>((event, emit) async {
      final imageFile = await getIt<ImagePickerService>().takePhotoWithCamera();
      if (imageFile == null) {
        emit(const PhotoStateError('No Photo taken'));
      } else {
        Either<Failure, String> failureOrsavedToGallery =
            await photoUsecases.savePhotoToGalleryUsecase(
                savePhotoToGalleryParams:
                    SavePhotoToGalleryParams(xfile: imageFile));
        failureOrsavedToGallery.fold(
          (l) => emit(PhotoStateError(l.toString())),
          (r) {
            getIt<SelectedTodolistBloc>().add(
                SelectedTodoListEventUpdateTodoNew(
                    todoUpdateParameters: TodoUpdateParameters(
                        uid: event.takeThumbnailPhotoParams.todoId,
                        thumbnailImageName: r)));
            if (_selectedThumbnailPhoto != null) {
              photoUsecases.deletePhotoFromGalleryUsecase(
                  fullPath: _selectedThumbnailPhoto!);

              final photoName = _selectedThumbnailPhoto!.split('/').last;
              add(PhotoEventAddToSyncPendingPhotos(
                  syncPendingPhotoParams: SyncPendingPhotoParams(
                      photoName: photoName,
                      method: SyncPendingPhotoMethod.delete)));
            }
            add(PhotoEventAddToSyncPendingPhotos(
                syncPendingPhotoParams: SyncPendingPhotoParams(
              photoName: r,
              method: SyncPendingPhotoMethod.upload,
            )));
            _selectedThumbnailPhoto = null;
          },
        );
      }
    });

    on<PhotoEventAddToSyncPendingPhotos>((event, emit) async {
      final success = await photoUsecases.addToSyncPendingPhotos(
        syncPendingPhotoParams: event.syncPendingPhotoParams,
      );
      Logger().d('Added to sync pending photos line $success');
    });

    on<PhotoEventSetSelectedThumbnailPhoto>((event, emit) {
      _selectedThumbnailPhoto = event.fullImagePath;
    });

    on<PhotoEventDeleteThumbnailPhotoFromGallery>((event, emit) async {
      if (_selectedThumbnailPhoto != null) {
        final deleted = await photoUsecases.deletePhotoFromGalleryUsecase(
            fullPath: _selectedThumbnailPhoto!);
        deleted.fold((l) => null, (r) {
          final photoName = _selectedThumbnailPhoto!.split('/').last;
          add(PhotoEventAddToSyncPendingPhotos(
              syncPendingPhotoParams: SyncPendingPhotoParams(
                  photoName: photoName,
                  method: SyncPendingPhotoMethod.delete)));
          _selectedThumbnailPhoto = null;
        });
      }
    });
  }
}
