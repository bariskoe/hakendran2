import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    Logger().d('SimpleBlocObserver ${bloc.runtimeType} $event');
  }

  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  // }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Logger().w('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }
}
