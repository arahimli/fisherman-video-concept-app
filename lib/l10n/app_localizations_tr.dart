// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Vogue Motion';

  @override
  String get create => 'OLUŞTUR';

  @override
  String get selectImage => 'RESİM SEÇ';

  @override
  String get changeImage => 'RESMİ DEĞİŞTİR';

  @override
  String get generateVideo => 'VİDEO\nOLUŞTUR';

  @override
  String get videoReady => 'VİDEO HAZIR';

  @override
  String get previewVideo => 'VİDEOYU İZLE';

  @override
  String get recentVideos => 'SON VİDEOLAR';

  @override
  String get viewAll => 'TÜMÜ';

  @override
  String get reset => 'Sıfırla';

  @override
  String get resetConfirmTitle => 'Sıfırla';

  @override
  String get resetConfirmMessage =>
      'Tüm değişiklikleri sıfırlamak istiyor musunuz?';

  @override
  String get no => 'Hayır';

  @override
  String get yes => 'Evet';

  @override
  String get imageProcessing => 'Resim işleniyor...';

  @override
  String get videoGenerating => 'Video oluşturuluyor...';

  @override
  String get videoGenerated => 'Video hazırlandı ✓';

  @override
  String get videoGenerationError => 'Video oluşturulurken hata oluştu';

  @override
  String get selectImageFirst => 'Önce bir resim seçin';

  @override
  String error(String error) {
    return 'Hata: $error';
  }
}
