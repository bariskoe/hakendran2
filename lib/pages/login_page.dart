import 'package:baristodolistapp/ui/standard_widgets/standart_text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../bloc/authentication/authentication_bloc.dart';
import '../dependency_injection.dart';
import '../routing.dart';
import '../ui/constants/constants.dart';
import '../ui/standard_widgets/loading_widget.dart';
import '../ui/standard_widgets/standard_page_widget.dart';
import '../ui/standard_widgets/standard_ui_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  bool loginShowing = true;
  var logger = Logger();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationStateError) {
          loading = false;
        }
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
                        loginShowing
                            ? const Text("Login")
                            : const Text('Register'),
                        const SizedBox(
                          height: UiConstantsPadding.large,
                        ),
                        TextField(
                          decoration: StandardTextfieldDecoration
                              .textFieldInputDecoration(
                                  context: context, labelText: "Email"),
                          controller: usernameController,
                        ),
                        const SizedBox(
                          height: UiConstantsPadding.large,
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: StandardTextfieldDecoration
                              .textFieldInputDecoration(
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
                                getIt<AuthenticationBloc>().add(
                                    AuthenticationEventSignInWithEmailAndPassword(
                                        email: usernameController.text,
                                        password: passwordController.text));
                              },
                              child: const Text('Login'))
                        ] else ...[
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              getIt<AuthenticationBloc>().add(
                                  AuthenticationEventCreateUserWithEmailAndPassword(
                                      email: usernameController.text,
                                      password: passwordController.text));
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
                        if (state is AuthenticationStateError) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: UiConstantsFontSize.large),
                            child: WarningTextWidget(
                                text: state.message,
                                fontsize: UiConstantsFontSize.regular),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
                if (loading) ...[const LoadingWidget()]
              ],
            ));
      },
    );
  }
}
