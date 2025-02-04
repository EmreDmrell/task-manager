import 'package:flutter/material.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
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
          title: "Welcome to Task Manager",
          body:
              "Stay organized and boost your productivity with our intuitive task management app",
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
          title: "Create & Organize Tasks",
          body:
              "Easily create new tasks, set due dates, and organize them with custom colors",
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
          title: "Track Your Progress",
          body:
              "Filter tasks by date and keep track of your daily achievements",
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
          title: "Sync Across Devices",
          body:
              "Your tasks are automatically synced when you're online, access them anywhere",
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
      skip: Text("Skip", style: textTheme.labelLarge),
      next: Text("Next", style: textTheme.labelLarge),
      done: Text(
        "Get Started",
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
