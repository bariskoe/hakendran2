// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/services/firebase_storage_service.dart';
import 'package:equatable/equatable.dart';

class UploadToFirebaseStorageParameters with EquatableMixin {
  /// this is the full path on the phone where the photo is stored
  final String pathToFile;
  final FirebaseStorageReferenceEnum firebaseStorageReferenceEnum;

  /// This is the name of the image consisting of the Todolist id,
  /// the Todo id and the image id.
  final String imageName;

  UploadToFirebaseStorageParameters(
      {required this.firebaseStorageReferenceEnum,
      required this.pathToFile,
      required this.imageName});

  @override
  List<Object?> get props => [
        pathToFile,
        firebaseStorageReferenceEnum,
        imageName,
      ];
}
