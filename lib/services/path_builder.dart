// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PathBuilder {
  final SharedPreferences sharedPreferences;
  late String photoFolderName;
  late String? appDocDir;
  late String? userId;

  PathBuilder({
    required this.sharedPreferences,
  });

  factory PathBuilder.forDi({
    required SharedPreferences sharedPreferences,
  }) {
    return PathBuilder(sharedPreferences: sharedPreferences)..initialize();
  }

  initialize() async {
    appDocDir = sharedPreferences
        .getString(StringConstants.spApplicationDocumentsDirectoryPath);
    if (appDocDir == null) {
      final docDir = await getApplicationDocumentsDirectory();
      appDocDir = docDir.path;
    }
    photoFolderName = StringConstants.photoFolderName;
    userId = sharedPreferences.getString(StringConstants.spFirebaseUserIDKey);
  }

  final delimiter = '/';
  String? _buildPathFromParts(List parts) {
    String path = '';
    if (parts.any((element) => element == null)) {
      return null;
    } else {
      for (String part in parts) {
        if (part == parts.last) {
          path += part;
        } else {
          path += '$part$delimiter';
        }
      }
      return path;
    }
  }

  get pathToLocalPhotoFolder {
    final String? path =
        _buildPathFromParts([appDocDir, userId, photoFolderName]);
    Logger().d('path ist $path');
    return path;
  }

  static photoNameExtractor(String path) {
    if (path.contains('/')) {
      final parts = path.split('/');
      return parts.last;
    } else {
      return path;
    }
  }
}
