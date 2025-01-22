import 'package:flutter/material.dart';
import 'package:frontend/core/services/sp_service.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var spService = SpService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          spService.getToken().toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
