import '../database/databse_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodoModel extends Equatable {
  final int? id;
  final String task;
  final bool accomplished;
  final int parentTodoListId;
  final RepeatPeriod repeatPeriod;
  final DateTime? accomplishedAt;

  const TodoModel({
    required this.id,
    required this.task,
    required this.accomplished,
    required this.parentTodoListId,
    this.repeatPeriod = RepeatPeriod.none,
    this.accomplishedAt,
  });

  factory TodoModel.fromMap(Map<dynamic, dynamic> map) {
    return TodoModel(
      id: map[DatabaseHelper.todosTableFieldId],
      task: map[DatabaseHelper.todosTableFieldTask],
      accomplished: AccomplishmentStatusExtension.deserialize(
          value: map[DatabaseHelper.todosTableFieldAccomplished]),
      parentTodoListId: map[DatabaseHelper.todosTableFieldTodoListId],
      repeatPeriod: RepeatPeriodExtension.deserialize(
        value: map[DatabaseHelper.todosTableFieldRepetitionPeriod],
      ),
      accomplishedAt: map[DatabaseHelper.todosTableFieldaccomplishedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[DatabaseHelper.todosTableFieldaccomplishedAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.todosTableFieldId: id,
      DatabaseHelper.todosTableFieldTask: task,
      DatabaseHelper.todosTableFieldAccomplished:
          AccomplishmentStatusExtension.serialize(accomplished: accomplished),
      DatabaseHelper.todosTableFieldTodoListId: parentTodoListId,
      DatabaseHelper.todosTableFieldRepetitionPeriod: repeatPeriod.serialize(),
      DatabaseHelper.todosTableFieldaccomplishedAt:
          accomplishedAt?.millisecondsSinceEpoch
    };
  }

  @override
  List<Object?> get props => [
        id,
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
    return 0;
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
