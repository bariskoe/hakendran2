import 'package:baristodolistapp/strings/string_constants.dart';

import '../assets.dart';
import '../ui/constants/constants.dart';
import 'package:flutter/material.dart';

Drawer mainPageDrawer() {
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
            //aboutBoxChildren: aboutBoxChildren,
          ),
        ],
      ),
    ),
  );
}
