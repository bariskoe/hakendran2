// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:baristodolistapp/domain/exceptions/exceptions.dart';
import 'package:baristodolistapp/domain/parameters/sync_pending_photo_params.dart';
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dependency_injection.dart';

class SyncPendingPhotoModel with EquatableMixin {
  final String imageName;
  final SyncPendingPhotoMethod method;
  final String? downloadUrl;

  SyncPendingPhotoModel({
    required this.imageName,
    required this.method,
    this.downloadUrl,
  });

  bool get hasDownloadUrl => downloadUrl != null;

  String get fullPath {
    final appDocDirPath = getIt<SharedPreferences>()
        .getString(StringConstants.spApplicationDocumentsDirectoryPath);
    final userId = getIt<SharedPreferences>()
        .getString(StringConstants.spFirebaseUserIDKey);
    final photoDirectoryName = StringConstants.photoFolderName;

    String fullpath = '$appDocDirPath/$userId/$photoDirectoryName/$imageName';
    Logger().d('fullpath, von dem das lokale bild geholt wird: $fullpath');
    return fullpath;
  }

  factory SyncPendingPhotoModel.fromParams(
      {required SyncPendingPhotoParams params}) {
    return SyncPendingPhotoModel(
      imageName: params.photoName,
      method: params.method,
      downloadUrl: params.downloadUrl,
    );
  }

  @override
  List<Object?> get props => [
        imageName,
        method,
        downloadUrl,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'relativePath': imageName,
      'method': method.name,
      'downloadUrl': downloadUrl,
    };
  }

  factory SyncPendingPhotoModel.fromMap(Map<String, dynamic> map) {
    final syncPendingPhotoMethod =
        stringToSyncPendingPhotoMethod(methodAsSting: map['method']);
    if (syncPendingPhotoMethod == null) {
      throw ConversionException(message: 'Invalid sync method');
    } else {
      return SyncPendingPhotoModel(
        imageName: map['relativePath'] as String,
        method: syncPendingPhotoMethod,
        downloadUrl:
            map['downloadUrl'] != null ? map['downloadUrl'] as String : null,
      );
    }
  }

  String toJson() => json.encode(toMap());
}

enum SyncPendingPhotoMethod { upload, download, delete }

extension SyncPendingPhotoMethodX on SyncPendingPhotoMethod {}

SyncPendingPhotoMethod? stringToSyncPendingPhotoMethod(
    {required String methodAsSting}) {
  List<String> values =
      SyncPendingPhotoMethod.values.map((e) => e.name).toList();
  if (values.contains(methodAsSting.toLowerCase())) {
    return SyncPendingPhotoMethod.values.firstWhere(
        (element) => element.name.toLowerCase() == methodAsSting.toLowerCase());
  } else {
    return null;
  }
}
