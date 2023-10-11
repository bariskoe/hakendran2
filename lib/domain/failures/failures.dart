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
