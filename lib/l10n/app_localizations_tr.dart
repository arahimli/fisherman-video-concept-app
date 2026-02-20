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
  String get history => 'Geçmiş';

  @override
  String get allVideos => 'Tüm Videolar';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get older => 'Eski';

  @override
  String get noVideos => 'Henüz video yok';

  @override
  String get noVideosDesc => 'İlk videonuzu oluşturun ve burada görün';

  @override
  String get deleteVideo => 'Videoyu Sil';

  @override
  String get deleteConfirm => 'Bu videoyu silmek istediğinize emin misiniz?';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'İptal';

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
  String error(Object error) {
    return 'Hata: $error';
  }

  @override
  String get filterByDate => 'Tarihe Göre Filtrele';

  @override
  String get allDates => 'Tüm Tarihler';

  @override
  String get loadMore => 'Daha Fazla Yükle';

  @override
  String videosCount(int count) {
    return '$count video';
  }

  @override
  String get videoPreviewTitle => 'ÖNİZLEME';

  @override
  String get shareSheet => 'PAYLAŞ';

  @override
  String get save => 'Kaydet';

  @override
  String get saving => 'Kaydediliyor...';

  @override
  String get saveToGallery => 'Galeriye kaydet';

  @override
  String get saveToGalleryDesc => 'Telefonunuzun galerisine kaydedilecek';

  @override
  String get videoSavedSuccess => '✓ Video galeriye kaydedildi';

  @override
  String get share => 'Paylaş';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram ve diğer uygulamalar';

  @override
  String get shareVideoText => 'Videoma bak!';

  @override
  String shareError(Object error) {
    return 'Paylaşım hatası: $error';
  }
}
