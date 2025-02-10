import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/snackbars.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/generated/l10n.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackbars.showErrorSnackbar(context, message: state.error);
          } else if (state is AuthLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.current.logIn,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 50,
                          )),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: S.current.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.current.emailFieldEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: S.current.password,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.current.passwordFieldEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: loginUser,
                    child: Text(
                      S.current.signIn,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, SignupPage.routeName),
                    child: RichText(
                      text: TextSpan(
                        text: S.current.dontHaveAccount,
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: S.current.signUp,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.blue,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
