import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Widget _buildImage(String assetName) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: SvgPicture.asset(
        'assets/$assetName',
        width: 250,
        height: 250,
        placeholderBuilder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(30.0),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Task Manager",
          body:
              "Stay organized and boost your productivity with our intuitive task management app",
          image: _buildImage('undraw_welcome-cats_tw36.svg'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: "Create & Organize Tasks",
          body:
              "Easily create new tasks, set due dates, and organize them with custom colors",
          image: _buildImage('undraw_to-do-list_dzdz.svg'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: "Track Your Progress",
          body:
              "Filter tasks by date and keep track of your daily achievements",
          image: _buildImage('undraw_progress-indicator_c14b.svg'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
        PageViewModel(
          title: "Sync Across Devices",
          body:
              "Your tasks are automatically synced when you're online, access them anywhere",
          image: _buildImage('undraw_synchronize_txyw.svg'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
            imagePadding: EdgeInsets.only(top: 40),
          ),
        ),
      ],
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Text("Next"),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.bold)),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: const Size(22.0, 10.0),
        activeColor: Colors.deepOrangeAccent,
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
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
