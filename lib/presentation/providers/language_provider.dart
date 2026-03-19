import 'package:flutter/foundation.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  bool get isEnglish => _currentLanguage == 'en';
  bool get isSpanish => _currentLanguage == 'es';

  void setLanguage(String language) {
    if (language != _currentLanguage && (language == 'en' || language == 'es')) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'en' ? 'es' : 'en';
    notifyListeners();
  }
}
