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
  String get history => 'Tarixçə';

  @override
  String get allVideos => 'Bütün Videolar';

  @override
  String get today => 'Bu gün';

  @override
  String get yesterday => 'Dünən';

  @override
  String get thisWeek => 'Bu həftə';

  @override
  String get thisMonth => 'Bu ay';

  @override
  String get older => 'Köhnə';

  @override
  String get noVideos => 'Hələ video yoxdur';

  @override
  String get noVideosDesc => 'İlk videonu yarat ki, burada görünsün';

  @override
  String get deleteVideo => 'Videonu Sil';

  @override
  String get deleteConfirm => 'Bu videonu silmək istədiyinizə əminsiniz?';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'İmtina';

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
  String error(Object error) {
    return 'Xəta: $error';
  }

  @override
  String get filterByDate => 'Tarixə görə süz';

  @override
  String get allDates => 'Bütün Tarixlər';

  @override
  String get loadMore => 'Daha çox yüklə';

  @override
  String get videoPreviewTitle => 'ÖNİZLƏMƏ';

  @override
  String get shareSheet => 'PAYLAŞ';

  @override
  String get save => 'Saxla';

  @override
  String get saving => 'Saxlanılır...';

  @override
  String get saveToGallery => 'Qalereya saxla';

  @override
  String get saveToGalleryDesc => 'Telefonun qaleresinda saxlanacaq';

  @override
  String get videoSavedSuccess => '✓ Video qalereya saxlanıldı';

  @override
  String get share => 'Paylaş';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram və digər tətbiqlər';

  @override
  String get shareVideoText => 'Bu videomu bax!';

  @override
  String shareError(Object error) => 'Paylaşma xətası: $error';

  @override
  String videosCount(int count) {
    return '$count video';
  }
}
