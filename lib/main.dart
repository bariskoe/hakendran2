import 'package:baristodolistapp/bloc/DataPreparation/bloc/data_preparation_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupDependencyInjectionWithGetIt();

  runApp(const BarisToDoListApp());
}

class BarisToDoListApp extends StatelessWidget {
  const BarisToDoListApp({Key? key}) : super(key: key);

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
        debugShowCheckedModeBanner: false,
        theme: Themes.darkGreenTheme(),
        darkTheme: ThemeData(
          colorSchemeSeed: Themes.darkGreenThemeSeed,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
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
