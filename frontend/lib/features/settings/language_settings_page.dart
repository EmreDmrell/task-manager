import 'package:flutter/material.dart';
import 'package:frontend/core/language/language_providert.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:provider/provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  static const routeName = '/language-settings';

  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.languageSettings),
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.chooseLanguage,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 20,
                      ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en',
                  groupValue: languageProvider.locale.languageCode,
                  onChanged: (value) => languageProvider.setLocale(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Español'),
                  value: 'es',
                  groupValue: languageProvider.locale.languageCode,
                  onChanged: (value) => languageProvider.setLocale(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Türkçe'),
                  value: 'tr',
                  groupValue: languageProvider.locale.languageCode,
                  onChanged: (value) => languageProvider.setLocale(value!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
