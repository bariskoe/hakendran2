import 'package:baristodolistapp/bloc/allTodoLists/all_todolists_bloc.dart';
import 'package:baristodolistapp/bloc/authentication/authentication_bloc.dart';
import 'package:baristodolistapp/dependency_injection.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource_impl.dart';
import 'package:baristodolistapp/routing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assets.dart';
import '../strings/string_constants.dart';
import '../ui/constants/constants.dart';

class MainPageDrawer extends Drawer {
  const MainPageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AboutListTile(
              icon: const Icon(Icons.info),
              applicationIcon: SizedBox(
                  height: UiConstantsSize.large,
                  child: Image.asset(ImageAssets.appLogo)),
              applicationName: StringConstants.applicationName,
              applicationVersion: '1.0.0',
              applicationLegalese: '\u{a9} Baris Cagdas Kösebas ${now.year}',
            ),
            GestureDetector(
                onTap: () async {
                  // No need to popUntil() LoginPage here. FirebaseAuth.instance.authStateChanges() listens for logouts
                  // and pushes to LoginPage.
                  //await FirebaseAuth.instance.signOut();
                  getIt<AuthenticationBloc>().add(AuthenticationEventSignOut());

                  getIt<SharedPreferences>()
                      .setString(StringConstants.spFirebaseIDTokenKey, '');
                  //Navigator.popUntil(context, (route) => route.se);
                  Get.offNamed(RoutingService.loginPage);
                },
                child: const Row(
                  children: [Icon(Icons.logout), Text('Logout')],
                )),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
                onTap: () async {
                  getIt<AllTodolistsBloc>().add(
                      AllTodolistsEventSynchronizeAllTodoListsWithBackend());
                },
                child: const Row(
                  children: [Icon(Icons.upload), Text('Synchronize')],
                ))
          ],
        ),
      ),
    );
  }
}
