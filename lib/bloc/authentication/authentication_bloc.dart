import 'package:baristodolistapp/database/databse_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dependency_injection.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../services/folder_creator.dart';
import '../../services/path_builder.dart';
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

    on<AuthenticationEventInitialize>((event, emit) {
      Logger().d('AuthenticationEventInitialize received');
    });

    on<AuthenticationEventIsSignedIn>((event, emit) {
      Logger().d('emitting authenticationstateIsLoggedIn');
      emit(AuthenticationStateLoggedIn());
    });
    on<AuthenticationEventEmitSignedOut>((event, emit) {
      emit(AuthenticationStateLoggedOut());
    });

    User? currentuser = getIt<FirebaseAuth>().currentUser;
    Logger().d('currentuser in AuthenticationBloc: $currentuser');
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
      failureOrUserCredential
          .fold((l) => emit(AuthenticationStateError(l.message)), (r) async {
        if (r.user != null) {
          if (r.user?.uid != null) {
            final uid = r.user?.uid;

            await getIt<SharedPreferences>()
                .setString(StringConstants.spFirebaseUserIDKey, uid!);
          }

          final idToken =
              await getIt<FirebaseAuth>().currentUser?.getIdToken(true);

          if (idToken != null) {
            getIt<SharedPreferences>()
                .setString(StringConstants.spFirebaseIDTokenKey, idToken);

            /// These Singletons have to be initialized on every log in
            /// in order to create the respective folder paths with the
            /// current Firebase id token
            await getIt<FolderCreator>().initialize();
            await getIt<PathBuilder>().initialize();
            add(AuthenticationEventIsSignedIn());
          }
        }
      });
    });

    on<AuthenticationEventRefreshToken>((event, emit) async {
      final idToken = await getIt<FirebaseAuth>().currentUser?.getIdToken(true);

      if (idToken != null) {
        getIt<SharedPreferences>()
            .setString(StringConstants.spFirebaseIDTokenKey, idToken);
      }
      Logger().i('idToken is $idToken');
    });

    on<AuthenticationEventCreateUserWithEmailAndPassword>((event, emit) async {
      final failureOrUserCredential =
          await authenticationRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      //! Bei einem Failure muss ein Error emitted werden
      failureOrUserCredential.fold((l) {
        emit(AuthenticationStateError(l.message));
      }, (r) async {
        if (r.user != null) {
          Logger().i('Credentials are: ${r.credential}');
          if (r.user?.uid != null) {
            final uid = r.user?.uid;

            await getIt<SharedPreferences>()
                .setString(StringConstants.spFirebaseUserIDKey, uid!);
          }

          final idToken =
              await getIt<FirebaseAuth>().currentUser?.getIdToken(true);

          if (idToken != null) {
            getIt<SharedPreferences>()
                .setString(StringConstants.spFirebaseIDTokenKey, idToken);
            getIt<AuthenticationBloc>().add(AuthenticationEventIsSignedIn());

            /// These Singletons have to be initialized on every registration
            /// in order to create the respective folder paths with the
            /// current Firebase id token
            await getIt<FolderCreator>().initialize();
            await getIt<PathBuilder>().initialize();
          }
        }
      });
    });

    on<AuthenticationEventSignOut>((event, emit) async {
      Logger().d('Signing out in AuthenticationBloc');
      await authenticationRepository.signOutFromFirebase();
      DatabaseHelper.onLogout();
      await getIt<SharedPreferences>()
          .remove(StringConstants.spFirebaseUserIDKey);
      await getIt<SharedPreferences>().remove(StringConstants.spDBTimestamp);
      emit(AuthenticationStateLoggedOut());
    });
  }
}
