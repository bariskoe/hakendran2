// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:baristodolistapp/database/databse_helper.dart';
import 'package:baristodolistapp/domain/entities/todo_entity.dart';
import 'package:baristodolistapp/models/todo_model.dart';

class TodoParameters {
  final String? uid;
  final String? task;
  final bool? accomplished;
  final String? parentTodoListId;
  final RepeatPeriod? repeatPeriod;
  final DateTime? accomplishedAt;

  TodoParameters({
    this.uid,
    this.task,
    this.accomplished,
    this.parentTodoListId,
    this.repeatPeriod,
    this.accomplishedAt,
  });

  factory TodoParameters.fromMap(Map<dynamic, dynamic> map) {
    return TodoParameters(
      uid: map[DatabaseHelper.todosTableFieldTodoUid],
      task: map[DatabaseHelper.todosTableFieldTask],
      accomplished: AccomplishmentStatusExtension.deserialize(
          value: map[DatabaseHelper.todosTableFieldAccomplished]),
      parentTodoListId: map[DatabaseHelper.todosTableFieldTodoListUid],
      repeatPeriod: RepeatPeriodExtension.deserialize(
        value: map[DatabaseHelper.todosTableFieldRepetitionPeriod],
      ),
      accomplishedAt: map[DatabaseHelper.todosTableFieldaccomplishedAt],
    );
  }

  factory TodoParameters.fromDomain(TodoEntity todoEntity) {
    return TodoParameters(
      uid: todoEntity.uid,
      accomplished: todoEntity.accomplished,
      accomplishedAt: todoEntity.accomplishedAt,
      parentTodoListId: todoEntity.parentTodoListId,
      repeatPeriod: todoEntity.repeatPeriod,
      task: todoEntity.task,
    );
  }

  TodoParameters copyWith({
    String? uid,
    String? task,
    bool? accomplished,
    String? parentTodoListId,
    RepeatPeriod? repeatPeriod,
    DateTime? accomplishedAt,
  }) {
    return TodoParameters(
      uid: uid ?? this.uid,
      task: task ?? this.task,
      accomplished: accomplished ?? this.accomplished,
      parentTodoListId: parentTodoListId ?? this.parentTodoListId,
      repeatPeriod: repeatPeriod ?? this.repeatPeriod,
      accomplishedAt: accomplishedAt ?? this.accomplishedAt,
    );
  }
}
