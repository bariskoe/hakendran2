// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../entities/todo_entity.dart';

class PhotoParameters with EquatableMixin {
  final XFile? xfile;
  final String? parentTodoListUid;
  final String? todoUid;
  final String? galleryPath;
  final TodoEntity? todoEntity;

  PhotoParameters({
    this.xfile,
    this.parentTodoListUid,
    this.todoUid,
    this.galleryPath,
    this.todoEntity,
  });

  factory PhotoParameters.fromDomain(TodoEntity entity) {
    return PhotoParameters(
        parentTodoListUid: entity.parentTodoListId,
        todoUid: entity.uid,
        galleryPath: entity.thumbnailImageName,
        todoEntity: entity);
  }

  PhotoParameters copyWith({
    XFile? xfile,
    String? parentTodoListUid,
    String? todoUid,
    String? galleryPath,
    TodoEntity? todoEntity,
  }) {
    return PhotoParameters(
      xfile: xfile ?? this.xfile,
      parentTodoListUid: parentTodoListUid ?? this.parentTodoListUid,
      todoUid: todoUid ?? this.todoUid,
      galleryPath: galleryPath ?? this.galleryPath,
      todoEntity: todoEntity ?? this.todoEntity,
    );
  }

  @override
  List<Object?> get props => [
        xfile,
        parentTodoListUid,
        todoUid,
        galleryPath,
        todoEntity,
      ];
}
