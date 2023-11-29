// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/models/todo_model.dart';
import 'package:baristodolistapp/services/path_builder.dart';
import 'package:equatable/equatable.dart';

class TodoEntity with EquatableMixin {
  final String? uid;
  final String task;
  final bool accomplished;
  final String parentTodoListId;
  final RepeatPeriod? repeatPeriod;
  final DateTime? accomplishedAt;
  final String? thumbnailImageName;

  TodoEntity(
      {this.uid,
      required this.task,
      required this.accomplished,
      required this.parentTodoListId,
      this.repeatPeriod,
      this.accomplishedAt,
      this.thumbnailImageName});

  Future<bool> imageExistsInPhone(String path) async {
    return await File(path).exists();
  }

  bool get hasImagePath => thumbnailImageName != null;

  Future<String?> get getFullImagePath async {
    if (!hasImagePath) {
      return null;
    } else {
      final pathBuilder = getIt<PathBuilder>();
      final pathToLocalPhotoFolder = pathBuilder.pathToLocalPhotoFolder;
      final completeFilepath = '$pathToLocalPhotoFolder/$thumbnailImageName';

      bool imageExists = await imageExistsInPhone(completeFilepath);
      if (imageExists) {
        return completeFilepath;
      } else {
        return null;
      }
    }
  }

  @override
  List<Object?> get props => [
        uid,
        task,
        parentTodoListId,
        repeatPeriod,
        accomplishedAt,
        accomplished,
        thumbnailImageName
      ];
}
