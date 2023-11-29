import 'package:equatable/equatable.dart';

import '../../models/sync_pending_photo_model.dart';

class SyncPendingPhotoParams with EquatableMixin {
  final String photoName;
  final SyncPendingPhotoMethod method;
  final String? downloadUrl;

  SyncPendingPhotoParams({
    required this.photoName,
    required this.method,
    this.downloadUrl,
  });

  @override
  List<Object?> get props => [
        photoName,
        method,
        downloadUrl,
      ];
}
