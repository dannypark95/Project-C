// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'CONNECTED';

  @override
  String get appSubtitle => '당신의 정신 건강 동반자';

  @override
  String get startChat => '채팅 시작';

  @override
  String get startConversation => '대화를 시작하세요';

  @override
  String get typeMessage => '메시지를 입력하세요...';

  @override
  String error(String error) {
    return '오류: $error';
  }

  @override
  String get welcomeMessage =>
      '안녕하세요! 저는 Aura입니다. 🌟\n\n저는 여러분의 감정과 경험을 듣고, 편안하고 비판적이지 않은 공간을 제공하기 위해 여기 있습니다. 오늘 하루 어떠셨나요? 어떤 이야기든 편하게 나눠주세요. 여러분의 감정을 존중하고, 함께 생각해보는 시간을 가져요.\n\n무엇이든 편하게 말씀해주세요. 저는 여기서 듣고 있어요.';
}
