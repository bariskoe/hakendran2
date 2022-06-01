import '../domain/entities/todolist_entity.dart';
import 'todo_model.dart';

import '../assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../database/databse_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TodoListModel extends TodoListEntity with EquatableMixin {
  TodoListModel({
    int? id,
    required String listName,
    required List<TodoModel> todoModels,
    required todoListCategory,
  }) : super(
          id: id,
          listName: listName,
          todoModels: todoModels,
          todoListCategory: todoListCategory,
        );

  @override
  List<Object?> get props => [
        id,
        listName,
        todoModels,
        todoListCategory,
      ];

  factory TodoListModel.fromMap(Map<dynamic, dynamic> map) => TodoListModel(
        id: map[DatabaseHelper.todoListsTableFieldId],
        listName: map[DatabaseHelper.todoListsTableFieldListName],
        todoModels:
            map[DatabaseHelper.todos].map((e) => TodoModel.fromMap(e)).toList(),
        todoListCategory: TodoListCategoryExtension.deserialize(
            map[DatabaseHelper.todoListsTableFieldCategory]),
      );

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.todoListsTableFieldId: id,
      DatabaseHelper.todoListsTableFieldListName: listName,
      DatabaseHelper.todos: todoModels.map((e) => e.toMap()).toList(),
      DatabaseHelper.todoListsTableFieldCategory: todoListCategory.serialize(),
    };
  }

  Map<String, dynamic> toMapForInsertNewListIntoDatabase() {
    return {
      DatabaseHelper.todoListsTableFieldId: id,
      DatabaseHelper.todoListsTableFieldListName: listName,
      DatabaseHelper.todoListsTableFieldCategory: todoListCategory.serialize(),
    };
  }

  int get numberOfUnaccomplishedTodos =>
      numberOfTodos - numberOfAccomplishedTodos;

  double get percentageOfAccomplishedTodos =>
      numberOfAccomplishedTodos / numberOfTodos;

  int get numberOfTodos => todoModels.length;

  int get numberOfAccomplishedTodos =>
      todoModels.where((element) => element.accomplished).length;

  bool get allAccomplished =>
      (todoModels.isNotEmpty && numberOfAccomplishedTodos == numberOfTodos);
  bool get atLeastOneAccomplished =>
      (todoModels.isNotEmpty && numberOfAccomplishedTodos > 0);
}

enum TodoListCategory {
  none,
  workout,
  education,
  nutrition,
  work,
  shopping,
  medication,
  animals,
  relaxation,
  cleanup,
  paperwork,
  friends
}

extension TodoListCategoryExtension on TodoListCategory {
  int serialize() {
    return TodoListCategory.values.indexWhere((element) => element == this);
  }

  static TodoListCategory deserialize(int categoryNumber) {
    return TodoListCategory.values[categoryNumber];
  }

  IconData getIcon() {
    switch (this) {
      case TodoListCategory.none:
        return Icons.pending_actions;

      case TodoListCategory.workout:
        return Icons.sports_tennis_rounded;

      case TodoListCategory.education:
        return Icons.menu_book_rounded;

      case TodoListCategory.nutrition:
        return Icons.blender;

      case TodoListCategory.work:
        return Icons.work;

      case TodoListCategory.shopping:
        return Icons.shopping_cart;

      case TodoListCategory.medication:
        return Icons.medical_services_outlined;

      case TodoListCategory.animals:
        return Icons.pets;

      case TodoListCategory.relaxation:
        return Icons.self_improvement_sharp;

      case TodoListCategory.cleanup:
        return Icons.cleaning_services_outlined;

      case TodoListCategory.paperwork:
        return Icons.mail_outline;

      case TodoListCategory.friends:
        return Icons.people;
    }
  }

  String getName(BuildContext context) {
    switch (this) {
      case TodoListCategory.none:
        return AppLocalizations.of(context)?.categoryNameNone ?? '';
      case TodoListCategory.workout:
        return AppLocalizations.of(context)?.categoryNameWorkout ?? '';
      case TodoListCategory.education:
        return AppLocalizations.of(context)?.categoryNameEducation ?? '';
      case TodoListCategory.nutrition:
        return AppLocalizations.of(context)?.categoryNameNutrition ?? '';
      case TodoListCategory.work:
        return AppLocalizations.of(context)?.categoryNameWork ?? '';
      case TodoListCategory.shopping:
        return AppLocalizations.of(context)?.categoryNameShopping ?? '';
      case TodoListCategory.medication:
        return AppLocalizations.of(context)?.categoryNameMedication ?? '';
      case TodoListCategory.animals:
        return AppLocalizations.of(context)?.categoryNameAnimals ?? '';
      case TodoListCategory.relaxation:
        return AppLocalizations.of(context)?.categoryNameRelaxation ?? '';
      case TodoListCategory.cleanup:
        return AppLocalizations.of(context)?.categoryNameCleanup ?? '';
      case TodoListCategory.paperwork:
        return AppLocalizations.of(context)?.categoryNamePaperwork ?? '';
      case TodoListCategory.friends:
        return AppLocalizations.of(context)?.categoryNameFriends ?? '';
    }
  }

  String getBackgroundImage() {
    switch (this) {
      case TodoListCategory.none:
        return ImageAssets.todoList;
      case TodoListCategory.workout:
        return ImageAssets.womanStretching;
      case TodoListCategory.education:
        return ImageAssets.library;
      case TodoListCategory.nutrition:
        return ImageAssets.fruits;
      case TodoListCategory.work:
        return ImageAssets.work;
      case TodoListCategory.shopping:
        return ImageAssets.shopping;
      case TodoListCategory.medication:
        return ImageAssets.pills;
      case TodoListCategory.animals:
        return ImageAssets.puppy;
      case TodoListCategory.relaxation:
        return ImageAssets.meditation;
      case TodoListCategory.cleanup:
        return ImageAssets.cleanup;
      case TodoListCategory.paperwork:
        return ImageAssets.folder;
      case TodoListCategory.friends:
        return ImageAssets.drinks;
    }
  }
}
