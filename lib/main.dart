import 'lifecycle_manager.dart';

import 'bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/allTodoLists/all_todolists_bloc.dart';
import 'dependency_injection.dart';
import 'pages/main_page.dart';
import 'simple_bloc_observer.dart';
import 'ui/themes/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjectionWithGetIt();

  //runApp(const ToDoListApp());

  BlocOverrides.runZoned(
    () {
      runApp(const BarisToDoListApp());
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class BarisToDoListApp extends StatelessWidget {
  const BarisToDoListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AllTodolistsBloc>()),
        BlocProvider(create: (context) => getIt<SelectedTodolistBloc>()),
        //   BlocProvider(
        //     create: (context) => SelectedTodolistBloc(),
        //   ),
        //   BlocProvider(
        //     create: (context) => AllTodolistsBloc(
        //         selectedTodolistBloc:
        //             BlocProvider.of<SelectedTodolistBloc>(context)),
        //   ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorSchemeSeed: Themes.blueThemeSeed,
            brightness: Brightness.light,
            useMaterial3: true,
            textTheme: const TextTheme(bodyMedium: TextStyle())),
        darkTheme: ThemeData(
          colorSchemeSeed: Themes.blueThemeSeed,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const LifeCycleManager(child: MainPage()),
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
      ),
    );
  }
}
