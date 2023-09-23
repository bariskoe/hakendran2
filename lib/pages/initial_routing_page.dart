import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../bloc/authentication/authentication_bloc.dart';
import '../routing.dart';
import 'data_preparation_page.dart';
import 'login_page.dart';

class InitialRoutingPage extends StatefulWidget {
  static String id = RoutingService.initialRoutingPage;
  const InitialRoutingPage({super.key});

  @override
  State<InitialRoutingPage> createState() => _InitialRoutingPageState();
}

class _InitialRoutingPageState extends State<InitialRoutingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationStateLoggedOut) {
            Logger()
                .d('state in AuthBloc is AuthenticationStateLoggedOut $state');
            Get.to(() => const LoginPage());
          }
          if (state is AuthenticationStateLoggedIn) {
            Logger()
                .d('state in AuthBloc is AuthenticationStateLoggedIn $state');
            Get.to(() => const DatapreparationPage());
            //Get.to(() => const MainPage());
          }
        },
        child: const LoginPage(),
      ),
    );
  }
}
