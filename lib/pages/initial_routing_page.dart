import 'package:baristodolistapp/bloc/authentication/authentication_bloc.dart';
import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/pages/data_preparation_page.dart';
import 'package:baristodolistapp/pages/login_page.dart';
import 'package:baristodolistapp/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../routing.dart';

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
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is AuthenticationStateLoggedOut) {
          return const LoginPage();
        }
        if (state is AuthenticationStateLoggedIn) {
          return const MainPage();
          //const DatapreparationPage();
        }
        return const LoginPage();
      }),
    );
  }
}
