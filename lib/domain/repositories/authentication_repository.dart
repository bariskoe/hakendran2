import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../failures/failures.dart';

abstract class AuthenticationRepository {
  Future<Either<AuthenticationFailure, UserCredential>>
      signInWithEmailAndPassword(
          {required String email, required String password});

  Future<Either<AuthenticationFailure, UserCredential>>
      createUserWithEmailAndPassword(
          {required String email, required String password});

  Future<void> signOutFromFirebase();
}
