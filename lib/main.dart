import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart'
    as getPackageTransitionsType;

import 'bloc/DataPreparation/bloc/data_preparation_bloc.dart';
import 'bloc/allTodoLists/all_todolists_bloc.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'lifecycle_manager.dart';
import 'pages/initial_routing_page.dart';
import 'routing.dart';
import 'ui/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupDependencyInjectionWithGetIt();

  runApp(const Hakendran());
}

class Hakendran extends StatelessWidget {
  const Hakendran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => getIt<AuthenticationBloc>()
              ..add(AuthenticationEventInitialize())),
        BlocProvider(create: (context) => getIt<DataPreparationBloc>()),
        BlocProvider(create: (context) => getIt<AllTodolistsBloc>()),
        BlocProvider(create: (context) => getIt<SelectedTodolistBloc>()),
      ],
      child: GetMaterialApp(
        defaultTransition: getPackageTransitionsType.Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 500),
        debugShowCheckedModeBanner: false,
        theme: Themes.darkGreenTheme(),
        // darkTheme: Themes.darkGreenThemeDark(),
        home: const LifeCycleManager(child: InitialRoutingPage()),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('de', ''),
          Locale('tr', ''),
        ],
        getPages: RoutingService.getXRoutes,
      ),
    );
  }
}
