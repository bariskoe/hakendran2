import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:logger/logger.dart';

import '../bloc/DataPreparation/bloc/data_preparation_bloc.dart';
import '../bloc/allTodoLists/all_todolists_bloc.dart';
import '../dependency_injection.dart';
import '../ui/standard_widgets/loading_widget.dart';
import 'main_page.dart';

class DatapreparationPage extends StatefulWidget {
  const DatapreparationPage({super.key});

  @override
  State<DatapreparationPage> createState() => _DatapreparationPageState();
}

class _DatapreparationPageState extends State<DatapreparationPage> {
  @override
  void initState() {
    super.initState();

    getIt<DataPreparationBloc>()
        .add(const DataPreparationEventSynchronizeIfNecessary());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<DataPreparationBloc, DataPreparationState>(
            listenWhen: (previous, current) {
              /// This line makes sure that this listener only listens if this Rpute is
              /// on top of the widget tree, meaning that it is visible
              return ModalRoute.of(context)?.isCurrent == true;
            },
            listener: (context, state) {
              Logger().d('state is $state');
              if (state is DataPreparationStateDataPreparationComplete) {
                Get.to(() => const MainPage());
                //Get.to(() => RoutingService.mainPage);
              }
            },
          ),
          BlocListener<AllTodolistsBloc, AllTodolistsState>(
            listener: (context, state) {
              Logger().d('state is $state');
              if (state is AllTodoListsStateDataPreparationComplete) {
                //Get.to(() => RoutingService.mainPage);
                Get.to(() => const MainPage());
              }
            },
          ),
        ],
        child: const Scaffold(
          body: Stack(
            children: [
              // Center(
              //   child: Text('Preparing data...'),
              // ),
              Center(child: LoadingWidget()),
            ],
          ),
        ));
  }
}
