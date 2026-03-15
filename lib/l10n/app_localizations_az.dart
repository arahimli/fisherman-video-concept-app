// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Old Fisherman';

  @override
  String get create => 'YARAT';

  @override
  String get selectImage => 'ŞƏKİL\nSEÇ';

  @override
  String get changeImage => 'ŞƏKİLİ\nDƏYİŞ';

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
  String get allLanguages => 'Hamısı';

  @override
  String get loadMore => 'Daha çox yüklə';

  @override
  String videosCount(int count) {
    return '$count video';
  }

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
  String get selectFromGallery => 'Foto kitabxanandan seç';

  @override
  String get takePhoto => 'Şəkil çək';

  @override
  String get takePhotoDesc => 'Kameranı aç və yeni şəkil çək';

  @override
  String shareError(Object error) {
    return 'Paylaşma xətası: $error';
  }

  @override
  String get settings => 'Parametrlər';

  @override
  String get watermark => 'Su İzi';

  @override
  String get imageWatermark => 'Şəkil Su İzi';

  @override
  String get imageWatermarkDesc => 'Videoya loqo və ya şəkil əlavə et';

  @override
  String get watermarkPosition => 'Su İzinin Mövqeyi';

  @override
  String get watermarkHint =>
      'Su izini söndürün ki, örtüksüz video yaratasınız.';

  @override
  String get watermarkChangeImage => 'Şəkili Dəyiş';

  @override
  String get watermarkRemove => 'Sil';

  @override
  String get watermarkSelectImage => 'Şəkil Seç';

  @override
  String get positionTopLeft => 'Yuxarı Sol';

  @override
  String get positionTopRight => 'Yuxarı Sağ';

  @override
  String get positionBottomLeft => 'Aşağı Sol';

  @override
  String get positionBottomRight => 'Aşağı Sağ';

  @override
  String get backToSelectImageTitle => 'Geri Qayıt';

  @override
  String get backToSelectImageMessage =>
      'Şəkil seçmə rejiminə qayıtmaq istədiyinizə əminsiniz?';

  @override
  String get pressBackAgainToExit => 'Çıxmaq üçün yenidən geri basın';

  @override
  String get support => 'Dəstək';

  @override
  String get supportDesc => 'Tətbiqi pulsuz saxlamaq üçün video reklam izləyin';

  @override
  String get shortVideo => 'Qısa Video';

  @override
  String get shortVideoDesc => 'Dəstək üçün qısa reklam izləyin';

  @override
  String get longVideo => 'Uzun Video';

  @override
  String get longVideoDesc => 'Əlavə dəstək üçün uzun reklam izləyin';

  @override
  String get watchAd => 'İzlə';

  @override
  String get thankYouSupport => 'Dəstəyiniz üçün təşəkkür edirik!';

  @override
  String get adsWatched => 'İzlənən reklamlar';

  @override
  String get adsWatchedToday => 'Bu gün';

  @override
  String get adsWatchedTotal => 'Ümumi';

  @override
  String get selectVideoLanguage => 'Dil seçin';

  @override
  String get englishVoice => 'İngilis';

  @override
  String get englishVoiceDesc => 'İngilis dilində səsləndirmə ilə video yarat';

  @override
  String get turkishVoice => 'Türk';

  @override
  String get turkishVoiceDesc => 'Türk dilində səsləndirmə ilə video yarat';

  @override
  String get russianVoice => 'Rus';

  @override
  String get russianVoiceDesc => 'Rus dilində səsləndirmə ilə video yarat';

  @override
  String get frenchVoice => 'Fransız';

  @override
  String get frenchVoiceDesc => 'Fransız dilində səsləndirmə ilə video yarat';

  @override
  String get arabicVoice => 'Ərəb';

  @override
  String get arabicVoiceDesc => 'Ərəb dilində səsləndirmə ilə video yarat';

  @override
  String get chineseVoice => 'Çin';

  @override
  String get chineseVoiceDesc =>
      'Mandarin Çin dilində səsləndirmə ilə video yarat';

  @override
  String get spanishVoice => 'İspan';

  @override
  String get spanishVoiceDesc => 'İspan dilində səsləndirmə ilə video yarat';

  @override
  String get hindiVoice => 'Hind';

  @override
  String get hindiVoiceDesc => 'Hind dilində səsləndirmə ilə video yarat';

  @override
  String get appLanguage => 'Dil';

  @override
  String get forceUpdateTitle => 'Yeniləmə Tələb Olunur';

  @override
  String get forceUpdateMessage =>
      'Yeni versiya mövcuddur. Davam etmək üçün yeniləyin.';

  @override
  String get forceUpdateButton => 'İNDİ YENİLƏ';
}
