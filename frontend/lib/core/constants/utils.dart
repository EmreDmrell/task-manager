import 'package:flutter/material.dart';

Color strengthenColor(Color color, double factor) {
  // ignore: deprecated_member_use
  int r = (color.red * factor).clamp(0, 255).toInt();
  // ignore: deprecated_member_use
  int g = (color.green * factor).clamp(0, 255).toInt();
  // ignore: deprecated_member_use
  int b = (color.blue * factor).clamp(0, 255).toInt();

  // ignore: deprecated_member_use
  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));

  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color) {
  // ignore: deprecated_member_use
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
