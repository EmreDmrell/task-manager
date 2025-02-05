import 'package:flutter/material.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: S.current.welcome,
          body: S.current.stayOrganizedDesc,
          image: Image.asset('assets/images/undraw_welcome-cats_tw36.png'),
          decoration: PageDecoration(
            titleTextStyle: textTheme.headlineMedium ??
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle:
                textTheme.bodyLarge ?? const TextStyle(fontSize: 16.0),
            imagePadding: const EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: S.current.manageTaskTitle,
          body: S.current.manageTaskDesc,
          image: Image.asset('assets/images/undraw_to-do-list_dzdz.png'),
          decoration: PageDecoration(
            titleTextStyle: textTheme.headlineMedium ??
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle:
                textTheme.bodyLarge ?? const TextStyle(fontSize: 16.0),
            imagePadding: const EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: S.current.trackProggressTitle,
          body: S.current.trackProggressDesc,
          image:
              Image.asset('assets/images/undraw_progress-indicator_c14b.png'),
          decoration: PageDecoration(
            titleTextStyle: textTheme.headlineMedium ??
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle:
                textTheme.bodyLarge ?? const TextStyle(fontSize: 16.0),
            imagePadding: const EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: S.current.syncTaskTitle,
          body: S.current.syncTaskDesc,
          image: Image.asset('assets/images/undraw_synchronize_txyw.png'),
          decoration: PageDecoration(
            titleTextStyle: textTheme.headlineMedium ??
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyTextStyle:
                textTheme.bodyLarge ?? const TextStyle(fontSize: 16.0),
            imagePadding: const EdgeInsets.only(top: 40),
          ),
        ),
      ],
      showSkipButton: true,
      skip: Text(S.current.skip, style: textTheme.labelLarge),
      next: Text(S.current.next, style: textTheme.labelLarge),
      done: Text(
        S.current.getStarted,
        style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }

  void _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }
}
