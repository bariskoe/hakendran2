import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

import '../bloc/DataPreparation/bloc/data_preparation_bloc.dart';
import '../dependency_injection.dart';

class ConnectivityService {
  final Connectivity connectivity;

  ConnectivityService(this.connectivity);

  factory ConnectivityService.forDi(Connectivity connectivity) {
    return ConnectivityService(connectivity)..initialize();
  }

  initialize() {
    connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        getIt<DataPreparationBloc>()
            .add(const DataPreparationEventSynchronizeIfNecessary());
      } else {}
      Logger().d('Connectivity status is $connectivityResult');
    });
  }
}
