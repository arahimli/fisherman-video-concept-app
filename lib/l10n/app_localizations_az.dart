// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Vogue Motion';

  @override
  String get create => 'YARAT';

  @override
  String get selectImage => 'ŞƏKİL SEÇ';

  @override
  String get changeImage => 'ŞƏKİLİ DƏYİŞ';

  @override
  String get generateVideo => 'VİDEO\nYARAT';

  @override
  String get videoReady => 'VİDEO HAZIRDIR';

  @override
  String get previewVideo => 'VİDEOYA BAX';

  @override
  String get recentVideos => 'SON VİDEOLAR';

  @override
  String get viewAll => 'HAMISI';

  @override
  String get reset => 'Sıfırla';

  @override
  String get resetConfirmTitle => 'Sıfırla';

  @override
  String get resetConfirmMessage =>
      'Bütün dəyişiklikləri sıfırlamaq istəyirsiniz?';

  @override
  String get no => 'Xeyr';

  @override
  String get yes => 'Bəli';

  @override
  String get imageProcessing => 'Şəkil emal olunur...';

  @override
  String get videoGenerating => 'Video yaradılır...';

  @override
  String get videoGenerated => 'Video hazırlandı ✓';

  @override
  String get videoGenerationError => 'Video yaradılarkən xəta baş verdi';

  @override
  String get selectImageFirst => 'Əvvəlcə şəkil seçin';

  @override
  String error(String error) {
    return 'Xəta: $error';
  }
}
