// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:baristodolistapp/domain/repositories/authentication_repository.dart';
import 'package:logger/logger.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FirebaseAuth firebaseAuth;

  AuthenticationRepositoryImpl({
    required this.firebaseAuth,
  });

  @override
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(userCredential);
    } catch (e) {
      //Implement custom Firebase Failures here
      Logger().e('Error in Login: $e');
      return Left(ApiFailure());
    }
  }

  @override
  Future<void> signOutFromFirebase() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      Logger().d('$e');
    }
  }

  @override
  Future<Either<Failure, UserCredential>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(userCredential);
    } catch (e) {
      //Implement custom Firebase Failures here
      return Left(ApiFailure());
    }
  }
}
