import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../strings/string_constants.dart';

class FolderCreator {
  SharedPreferences sharedPreferences;

  FolderCreator({required this.sharedPreferences});

  factory FolderCreator.forDi(SharedPreferences sharedPreferences) {
    return FolderCreator(sharedPreferences: sharedPreferences)..initialize();
  }

  initialize() async {
    final applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();

    final userId =
        sharedPreferences.getString(StringConstants.spFirebaseUserIDKey);
    final userFolder =
        Directory('${applicationDocumentsDirectory.path}/$userId');
    final userFolderExists = await userFolder.exists();
    if (!userFolderExists) {
      await userFolder.create();
    }
    final photoFolder = Directory(
        '${applicationDocumentsDirectory.path}/$userId/${StringConstants.photoFolderName}');
    final exists = await photoFolder.exists();
    if (!exists) {
      await photoFolder.create();
    }
  }
}
