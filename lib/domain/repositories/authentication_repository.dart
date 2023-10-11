import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<AuthenticationFailure, UserCredential>>
      createUserWithEmailAndPassword(
          {required String email, required String password});
  Future<void> signOutFromFirebase();
}
