import 'package:flutter/material.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/pages/add_new_task_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignupPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const SignupPage(),
      );
    case LoginPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );
    case AddNewTaskPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const AddNewTaskPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
