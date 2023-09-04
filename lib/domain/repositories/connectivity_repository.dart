import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ConnectivityRepository {
  Future<Either<Failure, bool>> isConnectedToInternet();
}
