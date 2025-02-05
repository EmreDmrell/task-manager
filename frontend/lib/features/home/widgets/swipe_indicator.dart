import 'package:flutter/material.dart';

class SwipeIndicatorWidget extends StatefulWidget {
  const SwipeIndicatorWidget({super.key});

  @override
  State<SwipeIndicatorWidget> createState() => _SwipeIndicatorWidgetState();
}

class _SwipeIndicatorWidgetState extends State<SwipeIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-0.7, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: const Icon(
        Icons.swipe_left_outlined,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}
