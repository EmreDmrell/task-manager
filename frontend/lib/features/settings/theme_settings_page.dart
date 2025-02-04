import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/theme/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  static const routeName = '/theme-settings';

  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Theme',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: const Text('System Default'),
                  value: 'system',
                  groupValue: themeProvider.themeMode == ThemeMode.system
                      ? 'system'
                      : themeProvider.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark',
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Light Mode'),
                  value: 'light',
                  groupValue: themeProvider.themeMode == ThemeMode.system
                      ? 'system'
                      : themeProvider.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark',
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Dark Mode'),
                  value: 'dark',
                  groupValue: themeProvider.themeMode == ThemeMode.system
                      ? 'system'
                      : themeProvider.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark',
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
