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
}
