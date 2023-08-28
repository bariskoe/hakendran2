import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dependency_injection.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../strings/string_constants.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  AuthenticationBloc({
    required this.authenticationRepository,
  }) : super(AuthenticationStateLoggedOut()) {
    // on<AuthenticationEvent>((event, emit) {

    // });

    on<AuthenticationEventIsSignedIn>((event, emit) {
      emit(AuthenticationStateLoggedIn());
    });
    on<AuthenticationEventEmitSignedOut>((event, emit) {
      emit(AuthenticationStateLoggedOut());
    });

    User? currentuser = getIt<FirebaseAuth>().currentUser;
    if (currentuser == null) {
      add(AuthenticationEventEmitSignedOut());
    } else {
      add(AuthenticationEventIsSignedIn());
    }

    on<AuthenticationEventSignInWithEmailAndPassword>((event, emit) async {
      final failureOrUserCredential =
          await authenticationRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      //! Bei einem Failure muss ein Error emitted werden
      failureOrUserCredential.fold((l) => null, (r) async {
        if (r.user != null) {
          Logger().i('Credentials are: ${r.credential}');
          final idToken =
              await getIt<FirebaseAuth>().currentUser?.getIdToken(true);

          if (idToken != null) {
            getIt<SharedPreferences>()
                .setString(StringConstants.spFirebaseIDTokenKey, idToken);
            getIt<AuthenticationBloc>().add(AuthenticationEventIsSignedIn());
          }
        }
      });
    });

    on<AuthenticationEventCreateUserWithEmailAndPassword>((event, emit) async {
      final failureOrUserCredential =
          await authenticationRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      //! Bei einem Failure muss ein Error emitted werden
      failureOrUserCredential.fold((l) => null, (r) async {
        if (r.user != null) {
          Logger().i('Credentials are: ${r.credential}');
          final idToken =
              await getIt<FirebaseAuth>().currentUser?.getIdToken(true);

          if (idToken != null) {
            getIt<SharedPreferences>()
                .setString(StringConstants.spFirebaseIDTokenKey, idToken);
            getIt<AuthenticationBloc>().add(AuthenticationEventIsSignedIn());
          }
        }
      });
    });

    on<AuthenticationEventSignOut>((event, emit) async {
      Logger().d('Signing out in AuthenticationBloc');
      await authenticationRepository.signOutFromFirebase();
      emit(AuthenticationStateLoggedOut());
    });
  }
}
