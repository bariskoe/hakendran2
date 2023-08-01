import 'package:baristodolistapp/routing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DatapreparationPage extends StatefulWidget {
  const DatapreparationPage({super.key});

  @override
  State<DatapreparationPage> createState() => _DatapreparationPageState();
}

class _DatapreparationPageState extends State<DatapreparationPage> {
  var signedIn = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        logger.d('Is logged in');
        setState(() {
          signedIn = true;
        });
        Navigator.pushNamed(context, Routing.mainPage);
      } else {
        logger.d('Is not logged in');
        setState(() {
          signedIn = false;
        });
        Navigator.pushNamed(context, Routing.loginPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
