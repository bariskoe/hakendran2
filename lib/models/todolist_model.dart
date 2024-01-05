import '../domain/entities/todo_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../assets.dart';
import '../database/databse_helper.dart';
import '../domain/entities/todolist_entity.dart';
import '../domain/parameters/todolist_entity_parameters.dart';
import 'todo_model.dart';

class TodoListModel extends TodoListEntity with EquatableMixin {
  TodoListModel({
    String? uid,
    required String listName,
    required List<TodoModel> todoModels,
    required TodoListCategory todoListCategory,
  }) : super(
          uid: uid,
          listName: listName,
          todoEntities: todoModels.map((e) => e.toDomain()).toList(),
          todoListCategory: todoListCategory,
        );

  @override
  List<Object?> get props => [
        uid,
        listName,
        todoEntities,
        todoListCategory,
      ];

  factory TodoListModel.fromMap(Map<dynamic, dynamic> map) => TodoListModel(
        uid: map[DatabaseHelper.todoListsTableFieldUid],
        listName: map[DatabaseHelper.todoListsTableFieldListName],
        todoModels:
            map[DatabaseHelper.todos].map((e) => TodoModel.fromMap(e)).toList(),
        todoListCategory: TodoListCategoryExtension.deserialize(
            map[DatabaseHelper.todoListsTableFieldCategory]),
      );

  factory TodoListModel.fromTodoListEntityParameters(
      TodoListEntityParameters todoListEntityParameters) {
    return TodoListModel(
      uid: todoListEntityParameters.uid,
      listName: todoListEntityParameters.listName ?? '',
      todoModels: todoListEntityParameters.todoModels ?? [],
      todoListCategory:
          todoListEntityParameters.todoListCategory ?? TodoListCategory.none,
    );
  }

  Map<String, dynamic> toMap() {
    var uuidLibrary = const Uuid();
    return {
      DatabaseHelper.todoListsTableFieldUid: uid ?? uuidLibrary.v1(),
      DatabaseHelper.todoListsTableFieldListName: listName,
      DatabaseHelper.todos: todoEntities,
      DatabaseHelper.todoListsTableFieldCategory: todoListCategory.serialize(),
    };
  }

  TodoListEntity toDomain() {
    return TodoListEntity(
        uid: uid,
        listName: listName,
        todoEntities: todoEntities,
        todoListCategory: todoListCategory);
  }

  Map<String, dynamic> toMapForInsertNewListIntoDatabase() {
    var uuidLibrary = const Uuid();
    return {
      DatabaseHelper.todoListsTableFieldUid: uid ?? uuidLibrary.v4(),
      DatabaseHelper.todoListsTableFieldListName: listName,
      DatabaseHelper.todoListsTableFieldCategory: todoListCategory.serialize(),
    };
  }

  int get numberOfUnaccomplishedTodos =>
      numberOfTodos - numberOfAccomplishedTodos;

  double get percentageOfAccomplishedTodos =>
      numberOfAccomplishedTodos / numberOfTodos;

  int get numberOfTodos => todoEntities.length;

  int get numberOfAccomplishedTodos =>
      todoEntities.where((element) => element.accomplished).length;

  bool get allAccomplished =>
      (todoEntities.isNotEmpty && numberOfAccomplishedTodos == numberOfTodos);

  bool get atLeastOneAccomplished =>
      (todoEntities.isNotEmpty && numberOfAccomplishedTodos > 0);
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

enum SynchronizationStatus {
  // No timestamp on Firestore + No timestamp in local database
  newUser,

  // Timestamp on Firestore exists + No Timestamp on local database
  // This can i.e. happen if the user deinstalls and reinstalls the app or if
  // he deletes the app data
  localDataDeleted,

  // Timestamp exists on Firestore and on local database + both are equal
  dataIsSynchronized,

  //Firestore Timestamp and local Timestamp exist + Firestore Timestamp older than local data timestamp
  localDataIsNewer,

  // If the remote data is not accessible i.e. due to connection failure
  unknown,
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
