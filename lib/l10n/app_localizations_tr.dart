// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Old Fisherman';

  @override
  String get create => 'OLUŞTUR';

  @override
  String get selectImage => 'RESİM\nSEÇ';

  @override
  String get changeImage => 'RESMİ\nDEĞİŞTİR';

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
  String get selectFromGallery => 'Fotoğraf kitaplığından seç';

  @override
  String get takePhoto => 'Fotoğraf Çek';

  @override
  String get takePhotoDesc => 'Kamerayı aç ve yeni fotoğraf çek';

  @override
  String shareError(Object error) {
    return 'Paylaşım hatası: $error';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get watermark => 'Filigran';

  @override
  String get imageWatermark => 'Görsel Filigran';

  @override
  String get imageWatermarkDesc => 'Videoya logo veya görsel ekle';

  @override
  String get watermarkPosition => 'Filigran Konumu';

  @override
  String get watermarkHint =>
      'Herhangi bir katman olmadan video oluşturmak için filigranı devre dışı bırakın.';

  @override
  String get watermarkChangeImage => 'Görseli Değiştir';

  @override
  String get watermarkRemove => 'Kaldır';

  @override
  String get watermarkSelectImage => 'Görsel Seç';

  @override
  String get positionTopLeft => 'Sol Üst';

  @override
  String get positionTopRight => 'Sağ Üst';

  @override
  String get positionBottomLeft => 'Sol Alt';

  @override
  String get positionBottomRight => 'Sağ Alt';

  @override
  String get backToSelectImageTitle => 'Geri Dön';

  @override
  String get backToSelectImageMessage =>
      'Resim seçme moduna geri dönmek istediğinize emin misiniz?';

  @override
  String get pressBackAgainToExit => 'Çıkmak için tekrar geri basın';

  @override
  String get support => 'Destek';

  @override
  String get supportDesc =>
      'Uygulamanın ücretsiz kalmasına yardımcı olmak için video reklam izleyin';

  @override
  String get shortVideo => 'Kısa Video';

  @override
  String get shortVideoDesc => 'Destek için kısa bir reklam izleyin';

  @override
  String get longVideo => 'Uzun Video';

  @override
  String get longVideoDesc => 'Ekstra destek için uzun bir reklam izleyin';

  @override
  String get watchAd => 'İzle';

  @override
  String get thankYouSupport => 'Desteğiniz için teşekkürler!';

  @override
  String get adsWatched => 'İzlenen reklamlar';

  @override
  String get adsWatchedToday => 'Bugün';

  @override
  String get adsWatchedTotal => 'Toplam';

  @override
  String get selectVideoLanguage => 'Dil Seçin';

  @override
  String get englishVoice => 'İngilizce';

  @override
  String get englishVoiceDesc => 'İngilizce seslendirme ile video oluştur';

  @override
  String get turkishVoice => 'Türkçe';

  @override
  String get turkishVoiceDesc => 'Türkçe seslendirme ile video oluştur';

  @override
  String get russianVoice => 'Rusça';

  @override
  String get russianVoiceDesc => 'Rusça seslendirme ile video oluştur';

  @override
  String get frenchVoice => 'Fransızca';

  @override
  String get frenchVoiceDesc => 'Fransızca seslendirme ile video oluştur';

  @override
  String get arabicVoice => 'Arapça';

  @override
  String get arabicVoiceDesc => 'Arapça seslendirme ile video oluştur';

  @override
  String get chineseVoice => 'Çince';

  @override
  String get chineseVoiceDesc =>
      'Mandarin Çincesi seslendirme ile video oluştur';

  @override
  String get spanishVoice => 'İspanyolca';

  @override
  String get spanishVoiceDesc => 'İspanyolca seslendirme ile video oluştur';

  @override
  String get hindiVoice => 'Hintçe';

  @override
  String get hindiVoiceDesc => 'Hintçe seslendirme ile video oluştur';
}
