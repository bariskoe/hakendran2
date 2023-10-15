import '../../domain/failures/failures.dart';
import '../../domain/repositories/connectivity_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  Connectivity connectivity;

  ConnectivityRepositoryImpl({
    required this.connectivity,
  });

  @override
  Future<Either<Failure, bool>> isConnectedToInternet() async {
    try {
      var connectivityResult = await connectivity.checkConnectivity();
      bool isConnected;
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        isConnected = true;
      } else {
        isConnected = false;
      }
      return Right(isConnected);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
