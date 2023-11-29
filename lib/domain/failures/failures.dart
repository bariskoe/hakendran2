// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure {}

class GeneralFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ApiFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AuthenticationFailure extends Failure with EquatableMixin {
  final String message;
  AuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class FirebaseFailure extends Failure with EquatableMixin {
  final String message;
  FirebaseFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class SavePhotoFailure extends Failure with EquatableMixin {
  String message;
  SavePhotoFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
