import '../../models/todo_model.dart';
import '../entities/todo_entity.dart';

class UpdateTodoModelParameters extends TodoModel {
  bool deleteImagePath;

  UpdateTodoModelParameters({
    required super.task,
    required super.accomplished,
    required super.parentTodoListId,
    required super.accomplishedAt,
    required super.thumbnailImageName,
    required super.repeatPeriod,
    required super.uid,
    this.deleteImagePath = false,
  });

  factory UpdateTodoModelParameters.fromDomain({
    required TodoEntity todoEntity,
  }) {
    return UpdateTodoModelParameters(
      task: todoEntity.task,
      accomplished: todoEntity.accomplished,
      parentTodoListId: todoEntity.parentTodoListId,
      accomplishedAt: todoEntity.accomplishedAt,
      thumbnailImageName: todoEntity.thumbnailImageName,
      repeatPeriod: todoEntity.repeatPeriod,
      uid: todoEntity.uid,
    );
  }

  @override
  UpdateTodoModelParameters copyWith(
      {String? task,
      bool? accomplished,
      String? parentTodoListId,
      DateTime? accomplishedAt,
      String? imagePath,
      RepeatPeriod? repeatPeriod,
      String? uid,
      bool? deleteImagePath,
      bool? deleteImageFromGallery}) {
    return UpdateTodoModelParameters(
        task: task ?? this.task,
        accomplished: accomplished ?? this.accomplished,
        parentTodoListId: parentTodoListId ?? this.parentTodoListId,
        accomplishedAt: accomplishedAt ?? this.accomplishedAt,
        thumbnailImageName: imagePath ?? thumbnailImageName,
        repeatPeriod: repeatPeriod ?? this.repeatPeriod,
        uid: uid ?? this.uid,
        deleteImagePath: deleteImagePath ?? false);
  }
}
