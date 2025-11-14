import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Mobile-first: max width for desktop, full width on mobile
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Language and theme switcher buttons (top right)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ThemeToggleButton(
                            currentThemeMode: currentThemeMode,
                            onThemeChanged: onThemeChanged,
                          ),
                          const SizedBox(width: 8),
                          _LanguageButton(
                            currentLocale: currentLocale,
                            onLocaleChanged: onLocaleChanged,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 96,
                    height: 96,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.appSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            onThemeChanged: onThemeChanged,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.startChat),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const _LanguageButton({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 4),
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇺🇸'),
              const SizedBox(width: 8),
              Text(
                'English',
                style: TextStyle(
                  fontWeight: currentLocale.languageCode == 'en'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (currentLocale.languageCode == 'en') ...[
                const Spacer(),
                Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ko'),
          child: Row(
            children: [
              const Text('🇰🇷'),
              const SizedBox(width: 8),
              Text(
                '한국어',
                style: TextStyle(
                  fontWeight: currentLocale.languageCode == 'ko'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (currentLocale.languageCode == 'ko') ...[
                const Spacer(),
                Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ],
      onSelected: (Locale locale) {
        onLocaleChanged(locale);
      },
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const _ThemeToggleButton({
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = currentThemeMode == ThemeMode.dark;
    
    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        size: 20,
      ),
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: () {
        onThemeChanged(
          isDark ? ThemeMode.light : ThemeMode.dark,
        );
      },
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

