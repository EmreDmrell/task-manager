import 'package:flutter/material.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/theme/theme_provider.dart';

class ThemeSettingsPage extends StatelessWidget {
  static const routeName = '/theme-settings';

  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.themeSettings),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.current.chooseTheme,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 20,
                        )),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: Text(S.current.systemDefault),
                  value: 'system',
                  groupValue: themeProvider.themeMode == ThemeMode.system
                      ? 'system'
                      : themeProvider.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark',
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
                RadioListTile<String>(
                  title: Text(S.current.lightMode),
                  value: 'light',
                  groupValue: themeProvider.themeMode == ThemeMode.system
                      ? 'system'
                      : themeProvider.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark',
                  onChanged: (value) => themeProvider.setThemeMode(value!),
                ),
                RadioListTile<String>(
                  title: Text(S.current.darkMode),
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
