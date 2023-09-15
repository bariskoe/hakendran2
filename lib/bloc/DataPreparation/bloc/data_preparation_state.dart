part of 'data_preparation_bloc.dart';

sealed class DataPreparationState extends Equatable {
  const DataPreparationState();

  @override
  List<Object> get props => [];
}

final class DataPreparationInitial extends DataPreparationState {}

class DataPreparationStateDataPreparationComplete
    extends DataPreparationState {}

class DataPreparationStateLoading extends DataPreparationState {}
