// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:baristodolistapp/services/firebase_storage_service.dart';

class DeleteFileFromFirebaseStorageParams with EquatableMixin {
  final FirebaseStorageReferenceEnum firebaseStorageReferenceEnum;

  final String fileName;

  DeleteFileFromFirebaseStorageParams(
      {required this.firebaseStorageReferenceEnum, required this.fileName});

  @override
  List<Object?> get props => [
        firebaseStorageReferenceEnum,
        fileName,
      ];
}
