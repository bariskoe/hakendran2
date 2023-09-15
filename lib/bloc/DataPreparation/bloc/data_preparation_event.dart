part of 'data_preparation_bloc.dart';

sealed class DataPreparationEvent extends Equatable {
  const DataPreparationEvent();

  @override
  List<Object> get props => [];
}

class DataPreparationEventCheckSynchronizationStatus
    extends DataPreparationEvent {
  const DataPreparationEventCheckSynchronizationStatus();

  @override
  List<Object> get props => [];
}

class DataPreparationEventSynchronizeIfNecessary extends DataPreparationEvent {
  const DataPreparationEventSynchronizeIfNecessary();
  @override
  List<Object> get props => [];
}
