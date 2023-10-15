// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:baristodolistapp/models/todo_model.dart';
import 'package:equatable/equatable.dart';

class TodoEntity with EquatableMixin {
  final String? uid;
  final String task;
  final bool accomplished;
  final String parentTodoListId;
  final RepeatPeriod? repeatPeriod;
  final DateTime? accomplishedAt;

  const TodoEntity({
    this.uid,
    required this.task,
    required this.accomplished,
    required this.parentTodoListId,
    this.repeatPeriod,
    this.accomplishedAt,
  });

  @override
  List<Object?> get props =>
      [uid, task, parentTodoListId, repeatPeriod, accomplishedAt, accomplished];
}
