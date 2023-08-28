part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationStateLoggedIn extends AuthenticationState {}

class AuthenticationStateLoggedOut extends AuthenticationState {}
