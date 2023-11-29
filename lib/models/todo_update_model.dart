// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/domain/parameters/todo_update_parameters.dart';
import 'package:baristodolistapp/models/todo_model.dart';
import 'package:equatable/equatable.dart';

class TodoUpdateModel with EquatableMixin {
  String uid;
  String? task;
  bool? accomplished;
  String? parentTodoListId;
  RepeatPeriod? repeatPeriod;
  DateTime? accomplishedAt;
  String? imagePath;
  String? downloadUrl;

  TodoUpdateModel({
    required this.uid,
    this.task,
    this.accomplished,
    this.parentTodoListId,
    this.repeatPeriod,
    this.accomplishedAt,
    this.imagePath,
    this.downloadUrl,
  });

  factory TodoUpdateModel.fromTodoUpdateParams(TodoUpdateParameters t) {
    return TodoUpdateModel(
        uid: t.uid,
        accomplished: t.accomplished,
        accomplishedAt: t.accomplishedAt,
        downloadUrl: t.downloadUrl,
        imagePath: t.thumbnailImageName,
        parentTodoListId: t.parentTodoListId,
        repeatPeriod: t.repeatPeriod);
  }

  @override
  List<Object?> get props => [
        uid,
        task,
        accomplished,
        parentTodoListId,
        repeatPeriod,
        repeatPeriod,
        imagePath,
        downloadUrl,
      ];
}
