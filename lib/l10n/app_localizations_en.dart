// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CONNECTED';

  @override
  String get appSubtitle => 'Your mental wellness companion';

  @override
  String get startChat => 'Start Chat';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get welcomeMessage =>
      'Hello! I\'m Aura. 🌟\n\nI\'m here to listen to your feelings and experiences, and to provide a safe, non-judgmental space for you to reflect and find comfort. How are you feeling today? Feel free to share whatever is on your mind.\n\nI\'m here to listen, validate your experiences, and support you through whatever you\'re going through. What would you like to talk about?';
}
