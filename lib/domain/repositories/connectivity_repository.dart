import 'package:dartz/dartz.dart';

import '../failures/failures.dart';

abstract class ConnectivityRepository {
  Future<Either<Failure, bool>> isConnectedToInternet();
}
