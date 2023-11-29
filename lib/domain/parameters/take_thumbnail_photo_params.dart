// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TakeThumbnailPhotoParams with EquatableMixin {
  final String todoId;
  TakeThumbnailPhotoParams({
    required this.todoId,
  });

  @override
  List<Object?> get props => [todoId];
}
