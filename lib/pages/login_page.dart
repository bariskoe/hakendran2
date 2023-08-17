import 'package:baristodolistapp/ui/constants/constants.dart';
import 'package:baristodolistapp/ui/standard_widgets/loading_widget.dart';
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
  TextEditingController usernameController =
      TextEditingController(text: 'bariskoe@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'asdfghjkl');

  bool loginShowing = true;
  var logger = Logger();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StandardPageWidget(
        showAppbar: false,
        child: Stack(
          children: [
            Container(
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
                            setState(() {
                              loading = true;
                            });
                            try {
                              var credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: usernameController.text,
                                      password: passwordController.text);
                              // No need to push to MainPage here. FirebaseAuth.instance.authStateChanges() on
                              // DataPreparationPage listens for auth changes and pushes to MainPage.
                              if (credential.user != null) {
                                Logger().i('Credentials are: $credential');
                                final idToken = await FirebaseAuth
                                    .instance.currentUser
                                    ?.getIdToken(true);
                                Logger().i('idtoken is $idToken');
                                logger.i("The credentials are $credential");
                                loading = false;
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                loading = false;
                              });
                              if (e.code == 'user-not-found') {
                                logger.d('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                logger.d(
                                    'Wrong password provided for that user.');
                              }
                            }
                          },
                          child: const Text('Login'))
                    ] else ...[
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: usernameController.text,
                                    password: passwordController.text);
                            if (credential.user != null) {
                              loading = false;
                            }

                            logger.i("The credentials are $credential");
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              loading = false;
                            });
                            if (e.code == 'weak-password') {
                              logger.e('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              logger.e(
                                  'The account already exists for that email.');
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
            ),
            if (loading) ...[const LoadingWidget()]
          ],
        ));
  }
}
