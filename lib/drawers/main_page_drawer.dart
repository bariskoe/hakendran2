import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  await FirebaseAuth.instance.signOut();
                },
                child: const Row(
                  children: [Icon(Icons.logout), Text('Logout')],
                ))
          ],
        ),
      ),
    );
  }
}
