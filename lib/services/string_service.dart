// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/strings/string_constants.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StringService {
  SharedPreferences sharedPreferences;

  StringService({
    required this.sharedPreferences,
  });

  factory StringService.forDi(SharedPreferences sharedPreferences) {
    return StringService(sharedPreferences: sharedPreferences)..initialize();
  }

  initialize() async {
    final applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final applicationDocumentsDirectorypath =
        applicationDocumentsDirectory.path;
    Logger().d('Setting path: $applicationDocumentsDirectorypath');
    sharedPreferences.setString(
        StringConstants.spApplicationDocumentsDirectoryPath,
        applicationDocumentsDirectorypath);
  }
}
