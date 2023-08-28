import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:synchronized/synchronized.dart';

import '../bloc/allTodoLists/all_todolists_bloc.dart';
import '../dependency_injection.dart';
import '../routing.dart';
import '../ui/standard_widgets/loading_widget.dart';

class DatapreparationPage extends StatefulWidget {
  const DatapreparationPage({super.key});

  @override
  State<DatapreparationPage> createState() => _DatapreparationPageState();
}

class _DatapreparationPageState extends State<DatapreparationPage> {
  var lock = Lock();

  @override
  void initState() {
    super.initState();
    // getIt<AllTodolistsBloc>().add(AllTodoListEvenGetAllTodoListsFromBackend());
    //! Hier muss der Synchrinisierungscheck rein
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllTodolistsBloc, AllTodolistsState>(
        listener: (context, state) {
      if (state is AllTodoListsStateDataPreparationComplete) {
        Get.toNamed(RoutingService.mainPage);
      }
    }, builder: (context, state) {
      return Scaffold(
        body: Stack(
          children: [
            const Center(
              child: Text('Preparing data...'),
            ),
            if (state is AllTodoListsStateLoading) ...[
              const Center(child: LoadingWidget()),
              const Text('Loading...')
            ]
          ],
        ),
      );
    });
  }
}
