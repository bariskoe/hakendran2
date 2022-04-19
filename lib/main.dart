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
        BlocProvider(
          create: (context) => SelectedTodolistBloc(),
        ),
        BlocProvider(
          create: (context) => AllTodolistsBloc(
              selectedTodolistBloc:
                  BlocProvider.of<SelectedTodolistBloc>(context)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.greenTheme(),
        home: LifeCycleManager(child: const MainPage()),
        localizationsDelegates: [
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


//TODO Include licenses of packages that require attribution, i.e. BackgroundFetch 