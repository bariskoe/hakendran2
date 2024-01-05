import 'dart:convert';

import '../strings/string_constants.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FirestoreDataInfoModel {
  /// When a user registers, there is no user doc yet. It exists after the first
  /// usage of firestore
  bool? userDocExists;

  /// The data in firestore is i.e. not accessible if there is no internet connection
  bool? dataIsAcessible;

  /// Timestamp of the last write operation in Firestore
  int? timestamp;

  /// Number of Todolists that are saved in Fiirestore
  int? count;
  FirestoreDataInfoModel({
    this.userDocExists,
    this.dataIsAcessible,
    this.timestamp,
    this.count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userDocExists': userDocExists,
      'dataIsAcessible': dataIsAcessible,
      StringConstants.spDBTimestamp: timestamp,
      StringConstants.firestoreFieldNumberOfLists: count,
    };
  }

  factory FirestoreDataInfoModel.fromMap(Map<String, dynamic> map) {
    return FirestoreDataInfoModel(
      userDocExists:
          map['userDocExists'] != null ? map['userDocExists'] as bool : null,
      dataIsAcessible: map['dataIsAcessible'] != null
          ? map['dataIsAcessible'] as bool
          : null,
      timestamp: map[StringConstants.spDBTimestamp] != null
          ? map[StringConstants.spDBTimestamp] as int
          : null,
      count: map[StringConstants.firestoreFieldNumberOfLists] != null
          ? map[StringConstants.firestoreFieldNumberOfLists] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FirestoreDataInfoModel.fromJson(String source) =>
      FirestoreDataInfoModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  /// Make a function that return the sum of a and b.
}
