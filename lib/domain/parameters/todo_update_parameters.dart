import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';

class TodoUpdateParameters with EquatableMixin {
  String uid;
  String? task;
  bool? accomplished;
  String? parentTodoListId;
  RepeatPeriod? repeatPeriod;
  DateTime? accomplishedAt;
  String? thumbnailImageName;
  String? downloadUrl;
  bool deleteImage;

  TodoUpdateParameters({
    required this.uid,
    this.task,
    this.accomplished,
    this.parentTodoListId,
    this.repeatPeriod,
    this.accomplishedAt,
    this.thumbnailImageName,
    this.downloadUrl,
    this.deleteImage = false,
  });

  @override
  List<Object?> get props => [
        uid,
        task,
        accomplished,
        parentTodoListId,
        repeatPeriod,
        repeatPeriod,
        thumbnailImageName,
        downloadUrl,
        deleteImage,
      ];
}
