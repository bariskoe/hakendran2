import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assets.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../dependency_injection.dart';
import '../pages/initial_routing_page.dart';
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
            Padding(
              padding: const EdgeInsets.all(UiConstantsPadding.xlarge),
              child: GestureDetector(
                  onTap: () async {
                    // No need to popUntil() LoginPage here. FirebaseAuth.instance.authStateChanges() listens for logouts
                    // and pushes to LoginPage.

                    getIt<AuthenticationBloc>()
                        .add(AuthenticationEventSignOut());

                    getIt<SharedPreferences>()
                        .remove(StringConstants.spFirebaseIDTokenKey);
                    Get.offUntil(
                      MaterialPageRoute(
                          builder: (context) => const InitialRoutingPage()),
                      (route) => false,
                    );
                  },
                  child: const Row(
                    children: [Icon(Icons.logout), Text('Logout')],
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            // GestureDetector(
            //     onTap: () async {
            //       DatabaseHelper.getAllEntriesOfsyncPendigTodolists();
            //       DatabaseHelper.getAllEntriesOfsyncPendigTodos();
            //     },
            //     child: const Row(
            //       children: [Icon(Icons.upload), Text('Get lists and todos')],
            //     ))
          ],
        ),
      ),
    );
  }
}
