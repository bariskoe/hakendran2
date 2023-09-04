part of 'authentication_bloc.dart';

class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationEventSignOut extends AuthenticationEvent {}

class AuthenticationEventSignInWithEmailAndPassword
    extends AuthenticationEvent {
  final String email;
  final String password;
  const AuthenticationEventSignInWithEmailAndPassword({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [email, password];
}

class AuthenticationEventCreateUserWithEmailAndPassword
    extends AuthenticationEvent {
  final String email;
  final String password;
  const AuthenticationEventCreateUserWithEmailAndPassword({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [email, password];
}

class AuthenticationEventIsSignedIn extends AuthenticationEvent {}

class AuthenticationEventIsSignedOut extends AuthenticationEvent {}

class AuthenticationEventEmitSignedOut extends AuthenticationEvent {}

class AuthenticationEventInitialize extends AuthenticationEvent {}
