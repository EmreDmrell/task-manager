import 'package:flutter/material.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/pages/add_new_task_page.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/features/settings/language_settings_page.dart';
import 'package:frontend/features/settings/theme_settings_page.dart';

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
    case ThemeSettingsPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ThemeSettingsPage(),
      );
    case LanguageSettingsPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const LanguageSettingsPage(),
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
