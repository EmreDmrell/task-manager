import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/language/language_providert.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/features/onboarding/pages/onboarding_screen.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:frontend/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:frontend/core/theme/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(ShowCaseWidget(
    builder: (context) => MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => TasksCubit()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserData();
    _checkFirstSeen();
  }

  Future<void> _checkFirstSeen() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
        _initialized = true;
      });
    } catch (e) {
      print('Error checking first seen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: context.watch<LanguageProvider>().locale,
      title: 'Task App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : !_hasSeenOnboarding
              ? const OnboardingScreen()
              : BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                  if (state is AuthLoggedIn) {
                    return const HomePage();
                  }
                  return const LoginPage();
                }),
    );
  }
}
