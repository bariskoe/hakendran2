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

  static bool? isConnectedToInternet;
  get getConnectivity => isConnectedToInternet;

  initialize() {
    connectivity.checkConnectivity().then((value) {
      Logger().d('ConnectivityResult im connectivity checker ist $value');
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        isConnectedToInternet = true;
      }
      if (value == ConnectivityResult.none) {
        isConnectedToInternet = false;
      }
    });

    connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        getIt<DataPreparationBloc>()
            .add(const DataPreparationEventSynchronizeIfNecessary());
        isConnectedToInternet = true;
      } else {
        isConnectedToInternet = false;
      }
      Logger().d('Connectivity status im listener is $connectivityResult');
    });
  }
}
