part of 'photo_bloc.dart';

sealed class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object> get props => [];
}

final class PhotoInitial extends PhotoState {}

final class PhotoStateError extends PhotoState {
  final String message;

  const PhotoStateError(this.message);

  @override
  List<Object> get props => [message];
}
