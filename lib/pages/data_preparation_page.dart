import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../bloc/DataPreparation/bloc/data_preparation_bloc.dart';
import '../bloc/allTodoLists/all_todolists_bloc.dart';
import '../dependency_injection.dart';
import '../routing.dart';
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
            listener: (context, state) {
              if (state is DataPreparationStateDataPreparationComplete) {
                Get.to(() => const MainPage());
              }
            },
          ),
          BlocListener<AllTodolistsBloc, AllTodolistsState>(
            listener: (context, state) {
              if (state is AllTodoListsStateDataPreparationComplete) {
                Get.to(() => RoutingService.mainPage);
                //Get.to(() => const MainPage());
              }
            },
          ),
        ],
        child: const Scaffold(
          body: Stack(
            children: [
              Center(
                child: Text('Preparing data...'),
              ),
              Center(child: LoadingWidget()),
              Text('Loading...')
            ],
          ),
        ));
  }
}
