// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/domain/parameters/delete_file_from_firebase_storage_params.dart';
import 'package:baristodolistapp/domain/parameters/upload_to_firebase_storage_parameters.dart';
import 'package:baristodolistapp/services/path_builder.dart';
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseStorageService {
  FirebaseStorage firebaseStorage;
  SharedPreferences sharedPreferences;
  late final Reference storageRef;
  late final Reference photoFolderRef;

  FirebaseStorageService({
    required this.firebaseStorage,
    required this.sharedPreferences,
  });

  factory FirebaseStorageService.forDi({
    required FirebaseStorage firebaseStorage,
    required SharedPreferences sharedPreferences,
  }) {
    return FirebaseStorageService(
      firebaseStorage: firebaseStorage,
      sharedPreferences: sharedPreferences,
    )..initialize();
  }

  initialize() {
    storageRef = firebaseStorage.ref();
  }

  Future<String?> uploadFileToFirebaseStorage(
      {required UploadToFirebaseStorageParameters
          uploadToFirebaseStorageParameters}) async {
    File file = File(uploadToFirebaseStorageParameters.pathToFile);
    Reference? referenceOnFirebase;

    switch (uploadToFirebaseStorageParameters.firebaseStorageReferenceEnum) {
      case FirebaseStorageReferenceEnum.thumbnailImages:
        final firebaseUserId =
            sharedPreferences.getString(StringConstants.spFirebaseUserIDKey);

        if (firebaseUserId != null) {
          referenceOnFirebase = storageRef
              .child(firebaseUserId)
              .child(StringConstants.photoFolderName)
              .child(uploadToFirebaseStorageParameters.imageName);
        }
    }
    if (referenceOnFirebase != null) {
      try {
        /// putFile returns an UploaddTask which can be used to observe the upload progress
        /// and the result
        await referenceOnFirebase.putFile(
            file,
            SettableMetadata(
              contentType: "image/jpeg",
            ));
        String downloadUrl = await referenceOnFirebase.getDownloadURL();
        Logger().d(
            "Die DownloadUrl an der entscheidenden Stelle ist: $downloadUrl");
        return downloadUrl;
      } on FirebaseException catch (e) {
        Logger().e('Error in uploadFileToFirebaseStorage: ${e.message}');
        return null;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  downloadFromFirebaseStorage(String path) async {
    final appDocDirPath = getIt<SharedPreferences>()
        .getString(StringConstants.spApplicationDocumentsDirectoryPath);
    final file = File('$appDocDirPath/$path');
    final firebaseUserId =
        sharedPreferences.getString(StringConstants.spFirebaseUserIDKey);
    final photoname = PathBuilder.photoNameExtractor(path);
    final imageRef = storageRef
        .child(firebaseUserId!)
        .child(StringConstants.photoFolderName)
        .child(photoname);
    await file.create(recursive: true);
    await imageRef.writeToFile(file);
    // downloadTask.snapshotEvents.listen((taskSnapshot) {
    //   switch (taskSnapshot.state) {
    //     case TaskState.running:
    //       () {
    //         Logger().d('download running');
    //       };
    //     case TaskState.paused:
    //       () {
    //         Logger().d('download paused');
    //       };
    //     case TaskState.success:
    //       () {
    //         Logger().d('download success');
    //       };
    //     case TaskState.canceled:
    //       () {
    //         Logger().d('download canceled');
    //       };
    //     case TaskState.error:
    //       () {
    //         Logger().d('download error');
    //       };
    //   }
    // });
  }

  Future<bool> deleteFileFromFirebaseStorage(
      {required DeleteFileFromFirebaseStorageParams
          deleteFileFromFirebaseStorageParams}) async {
    try {
      // Reference finalReference = storageRef.child(
      //     "${deleteFileFromFirebaseStorageParams.firebaseStorageReferenceEnum.getNameOfFolderOnStorageBucket()}/${deleteFileFromFirebaseStorageParams.fileName}");
      final firebaseUserId =
          sharedPreferences.getString(StringConstants.spFirebaseUserIDKey);
      Reference? referenceOnFirebase;
      if (firebaseUserId != null) {
        referenceOnFirebase = storageRef
            .child(firebaseUserId)
            .child(StringConstants.photoFolderName)
            .child(deleteFileFromFirebaseStorageParams.fileName);
        await referenceOnFirebase.delete();
      }
      return true;
    } catch (e) {
      Logger().e('Error in deleteFileFromFirebaseStorage: $e');
      return false;
    }
  }
}

enum FirebaseStorageReferenceEnum { thumbnailImages }

extension FolderNameOnStorage on FirebaseStorageReferenceEnum {
  String getNameOfFolderOnStorageBucket() {
    switch (this) {
      case FirebaseStorageReferenceEnum.thumbnailImages:
        return StringConstants.photoFolderName;
    }
  }
}
