import 'package:baristodolistapp/ui/constants/constants.dart';
import 'package:baristodolistapp/ui/standard_widgets/standard_page_widget.dart';
import 'package:baristodolistapp/ui/standard_widgets/standard_ui_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginShowing = true;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StandardPageWidget(
        showAppbar: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/hakendran_loginpage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: UiConstantsPadding.large),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginShowing ? const Text("Login") : const Text('Register'),
                const SizedBox(
                  height: UiConstantsPadding.large,
                ),
                TextField(
                  decoration:
                      StandardTextfieldDecoration.textFieldInputDecoration(
                          context: context, labelText: "Email"),
                  controller: usernameController,
                ),
                const SizedBox(
                  height: UiConstantsPadding.large,
                ),
                TextField(
                  controller: passwordController,
                  decoration:
                      StandardTextfieldDecoration.textFieldInputDecoration(
                    context: context,
                    labelText: "Password",
                  ),
                ),
                const SizedBox(
                  height: UiConstantsPadding.large,
                ),
                if (loginShowing) ...[
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          // final credential =
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: usernameController.text,
                                  password: passwordController.text);
                          // No need to push to MainPage here. FirebaseAuth.instance.authStateChanges() on
                          // DataPreparationPage listens for auth changes and pushes to MainPage.
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            logger.d('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            logger.d('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: const Text('Login'))
                ] else ...[
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: usernameController.text,
                                password: passwordController.text);
                        // setState(() {
                        //   if (credential.user != null) {
                        //     Navigator.pushNamed(context, Routing.mainPage);
                        //   }
                        // });
                        logger.i("The credentials are $credential");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          logger.e('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          logger
                              .e('The account already exists for that email.');
                        }
                      } catch (e) {
                        logger.e('Error Message: $e');
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
                const SizedBox(
                  height: UiConstantsPadding.large,
                ),
                if (loginShowing) ...[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loginShowing = false;
                      });
                    },
                    child: const Text('No Account? Create one'),
                  )
                ] else ...[
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loginShowing = true;
                        });
                      },
                      child: const Text('I have an account'))
                ],
              ],
            ),
          ),
        ));
  }
}
