import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../database/databse_helper.dart';
import '../domain/entities/todo_entity.dart';
import '../domain/parameters/todo_parameters.dart';

class TodoModel extends TodoEntity with EquatableMixin {
  final String? uid;
  final String task;
  final bool accomplished;
  final String parentTodoListId;
  final RepeatPeriod? repeatPeriod;
  final DateTime? accomplishedAt;

  const TodoModel({
    required this.task,
    required this.accomplished,
    required this.parentTodoListId,
    this.uid,
    this.accomplishedAt,
    this.repeatPeriod = RepeatPeriod.none,
  }) : super(
          task: task,
          accomplished: accomplished,
          parentTodoListId: parentTodoListId,
        );

  TodoModel copyWith({
    String? uid,
    String? task,
    bool? accomplished,
    String? parentTodoListId,
    RepeatPeriod? repeatPeriod,
    DateTime? accomplishedAt,
  }) {
    return TodoModel(
      uid: uid ?? this.uid,
      task: task ?? this.task,
      accomplished: accomplished ?? this.accomplished,
      parentTodoListId: parentTodoListId ?? this.parentTodoListId,
      repeatPeriod: repeatPeriod ?? this.repeatPeriod,
      accomplishedAt: accomplishedAt ?? this.accomplishedAt,
    );
  }

  factory TodoModel.fromMap(Map<dynamic, dynamic> map) {
    return TodoModel(
      uid: map[DatabaseHelper.todosTableFieldTodoUid],
      task: map[DatabaseHelper.todosTableFieldTask],
      accomplished: AccomplishmentStatusExtension.deserialize(
          value: map[DatabaseHelper.todosTableFieldAccomplished]),
      parentTodoListId: map[DatabaseHelper.todosTableFieldTodoListUid],
      repeatPeriod: RepeatPeriodExtension.deserialize(
        value: map[DatabaseHelper.todosTableFieldRepetitionPeriod],
      ),
      accomplishedAt: map[DatabaseHelper.todosTableFieldaccomplishedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[DatabaseHelper.todosTableFieldaccomplishedAt])
          : null,
    );
  }

  factory TodoModel.fromTodoParameters(TodoParameters todoParameters) {
    var uuidLibrary = const Uuid();
    return TodoModel(
        task: todoParameters.task ?? '',
        accomplished: todoParameters.accomplished ?? false,
        parentTodoListId: todoParameters.parentTodoListId ?? '',
        accomplishedAt: todoParameters.accomplishedAt,
        repeatPeriod: todoParameters.repeatPeriod ?? RepeatPeriod.none,
        //! uid should probably be required

        uid: todoParameters.uid ?? uuidLibrary.v1());
  }

  Map<String, dynamic> toMap() {
    var uuidLibrary = const Uuid();
    return {
      DatabaseHelper.todosTableFieldTodoUid: uid ?? uuidLibrary.v1(),
      DatabaseHelper.todosTableFieldTask: task,
      DatabaseHelper.todosTableFieldAccomplished:
          AccomplishmentStatusExtension.serialize(accomplished: accomplished),
      DatabaseHelper.todosTableFieldTodoListUid: parentTodoListId,
      DatabaseHelper.todosTableFieldRepetitionPeriod: repeatPeriod?.serialize(),
      DatabaseHelper.todosTableFieldaccomplishedAt:
          accomplishedAt?.millisecondsSinceEpoch
    };
  }

  @override
  List<Object?> get props => [
        uid,
        task,
        accomplished,
        parentTodoListId,
        repeatPeriod,
        accomplishedAt,
      ];

  bool shouldResetAccomplishmentStatus() {
    if (accomplishedAt == null) {
      return false;
    } else {
      DateTime now = DateTime.now();
      bool timeHasPassed = accomplishedAt!.isBefore(now);
      switch (repeatPeriod) {
        case RepeatPeriod.none:
          return false;

        case RepeatPeriod.daily:
          if (timeHasPassed && accomplishedAt!.day != now.day) {
            return true;
          }
          break;
        //.weekday returns an int, representing the day. I.E 7 is Sunday. True
        //should be returned if a new week has started (every Monday) since the
        //accomplishedAt. If today is tuesday (2) and accomplishedAt was on a
        //Saturday (6) then 2-6 is negative, which means a Monday was in between
        //and therefor true should be returned. This is valid for all combinations
        //of now and accomplishedAt.
        case RepeatPeriod.weekly:
          if (timeHasPassed && (now.weekday - accomplishedAt!.weekday) < 0) {
            return true;
          }
          break;
        case RepeatPeriod.monthly:
          if (timeHasPassed && (accomplishedAt!.month != now.month)) {
            return true;
          }
          break;
        default:
          return false;
      }
      return false;
    }
  }
}

extension AccomplishmentStatusExtension on TodoModel {
  static bool deserialize({required final int value}) {
    switch (value) {
      case 0:
        return false;
      case 1:
        return true;
    }
    return false;
  }

  static int serialize({required bool accomplished}) {
    switch (accomplished) {
      case false:
        return 0;
      case true:
        return 1;
    }
  }
}

enum RepeatPeriod {
  none,
  daily,
  weekly,
  monthly,
}

extension RepeatPeriodExtension on RepeatPeriod {
  static RepeatPeriod deserialize({required final int value}) {
    return RepeatPeriod.values[value];
  }

  int serialize() {
    return RepeatPeriod.values.indexWhere((element) => element == this);
  }

  String getName(BuildContext context) {
    switch (this) {
      case RepeatPeriod.none:
        return AppLocalizations.of(context)?.repetitionPeriodNone ?? 'null';
      case RepeatPeriod.daily:
        return AppLocalizations.of(context)?.repetitionPeriodDaily ?? 'null';
      case RepeatPeriod.weekly:
        return AppLocalizations.of(context)?.repetitionPeriodWeekly ?? 'null';
      case RepeatPeriod.monthly:
        return AppLocalizations.of(context)?.repetitionPeriodMonthly ?? 'null';
    }
  }
}
