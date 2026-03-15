// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'बूढ़ा मछुआरा';

  @override
  String get create => 'बनाएं';

  @override
  String get selectImage => 'छवि\nचुनें';

  @override
  String get changeImage => 'छवि\nबदलें';

  @override
  String get generateVideo => 'वीडियो\nबनाएं';

  @override
  String get videoReady => 'वीडियो तैयार';

  @override
  String get previewVideo => 'वीडियो पूर्वावलोकन';

  @override
  String get recentVideos => 'हाल के वीडियो';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get history => 'इतिहास';

  @override
  String get allVideos => 'सभी वीडियो';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get older => 'पुराना';

  @override
  String get noVideos => 'अभी तक कोई वीडियो नहीं';

  @override
  String get noVideosDesc => 'इसे यहां देखने के लिए अपना पहला वीडियो बनाएं';

  @override
  String get deleteVideo => 'वीडियो हटाएं';

  @override
  String get deleteConfirm => 'क्या आप वाकई इस वीडियो को हटाना चाहते हैं?';

  @override
  String get delete => 'हटाएं';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get reset => 'रीसेट';

  @override
  String get resetConfirmTitle => 'रीसेट';

  @override
  String get resetConfirmMessage =>
      'क्या आप सभी परिवर्तनों को रीसेट करना चाहते हैं?';

  @override
  String get no => 'नहीं';

  @override
  String get yes => 'हां';

  @override
  String get imageProcessing => 'छवि प्रसंस्करण...';

  @override
  String get videoGenerating => 'वीडियो बन रहा है...';

  @override
  String get videoGenerated => 'वीडियो बनाया गया ✓';

  @override
  String get videoGenerationError => 'वीडियो बनाते समय त्रुटि हुई';

  @override
  String get selectImageFirst => 'कृपया पहले एक छवि चुनें';

  @override
  String error(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String get filterByDate => 'तारीख से फ़िल्टर करें';

  @override
  String get allDates => 'सभी तारीखें';

  @override
  String get allLanguages => 'सभी';

  @override
  String get loadMore => 'और लोड करें';

  @override
  String videosCount(int count) {
    return '$count वीडियो';
  }

  @override
  String get videoPreviewTitle => 'पूर्वावलोकन';

  @override
  String get shareSheet => 'शेयर करें';

  @override
  String get save => 'सहेजें';

  @override
  String get saving => 'सहेजा जा रहा है...';

  @override
  String get saveToGallery => 'गैलरी में सहेजें';

  @override
  String get saveToGalleryDesc => 'आपके फ़ोन की गैलरी में सहेजा जाएगा';

  @override
  String get videoSavedSuccess => '✓ वीडियो गैलरी में सहेजा गया';

  @override
  String get share => 'शेयर';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram और अन्य ऐप्स';

  @override
  String get shareVideoText => 'मेरा वीडियो देखें!';

  @override
  String get selectFromGallery => 'अपनी फोटो लाइब्रेरी से चुनें';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get takePhotoDesc => 'कैमरा खोलें और नई फोटो लें';

  @override
  String shareError(Object error) {
    return 'शेयर त्रुटि: $error';
  }

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get watermark => 'वॉटरमार्क';

  @override
  String get imageWatermark => 'छवि वॉटरमार्क';

  @override
  String get imageWatermarkDesc => 'वीडियो पर लोगो या छवि लगाएं';

  @override
  String get watermarkPosition => 'वॉटरमार्क स्थिति';

  @override
  String get watermarkHint =>
      'बिना किसी ओवरले के वीडियो बनाने के लिए वॉटरमार्क अक्षम करें।';

  @override
  String get watermarkChangeImage => 'छवि बदलें';

  @override
  String get watermarkRemove => 'हटाएं';

  @override
  String get watermarkSelectImage => 'छवि चुनें';

  @override
  String get positionTopLeft => 'ऊपर बाएं';

  @override
  String get positionTopRight => 'ऊपर दाएं';

  @override
  String get positionBottomLeft => 'नीचे बाएं';

  @override
  String get positionBottomRight => 'नीचे दाएं';

  @override
  String get backToSelectImageTitle => 'वापस जाएं';

  @override
  String get backToSelectImageMessage =>
      'क्या आप वाकई छवि चयन मोड में वापस जाना चाहते हैं?';

  @override
  String get pressBackAgainToExit =>
      'बाहर निकलने के लिए फिर से वापस दबाएं';

  @override
  String get support => 'सहायता';

  @override
  String get supportDesc =>
      'ऐप को मुफ्त रखने और विकास का समर्थन करने के लिए एक वीडियो विज्ञापन देखें';

  @override
  String get shortVideo => 'छोटा वीडियो';

  @override
  String get shortVideoDesc =>
      'ऐप का समर्थन करने के लिए एक छोटा विज्ञापन देखें';

  @override
  String get longVideo => 'लंबा वीडियो';

  @override
  String get longVideoDesc =>
      'अतिरिक्त समर्थन के लिए एक लंबा विज्ञापन देखें';

  @override
  String get watchAd => 'देखें';

  @override
  String get thankYouSupport => 'आपके समर्थन के लिए धन्यवाद!';

  @override
  String get adsWatched => 'देखे गए विज्ञापन';

  @override
  String get adsWatchedToday => 'आज';

  @override
  String get adsWatchedTotal => 'कुल';

  @override
  String get selectVideoLanguage => 'भाषा चुनें';

  @override
  String get englishVoice => 'अंग्रेज़ी';

  @override
  String get englishVoiceDesc => 'अंग्रेज़ी में कथन के साथ वीडियो बनाएं';

  @override
  String get turkishVoice => 'तुर्की';

  @override
  String get turkishVoiceDesc => 'तुर्की में कथन के साथ वीडियो बनाएं';

  @override
  String get russianVoice => 'रूसी';

  @override
  String get russianVoiceDesc => 'रूसी में कथन के साथ वीडियो बनाएं';

  @override
  String get frenchVoice => 'फ्रेंच';

  @override
  String get frenchVoiceDesc => 'फ्रेंच में कथन के साथ वीडियो बनाएं';

  @override
  String get arabicVoice => 'अरबी';

  @override
  String get arabicVoiceDesc => 'अरबी में कथन के साथ वीडियो बनाएं';

  @override
  String get chineseVoice => 'चीनी';

  @override
  String get chineseVoiceDesc => 'मंदारिन चीनी में कथन के साथ वीडियो बनाएं';

  @override
  String get spanishVoice => 'स्पेनिश';

  @override
  String get spanishVoiceDesc => 'स्पेनिश में कथन के साथ वीडियो बनाएं';

  @override
  String get hindiVoice => 'हिंदी';

  @override
  String get hindiVoiceDesc => 'हिंदी में कथन के साथ वीडियो बनाएं';

  @override
  String get forceUpdateTitle => 'अपडेट आवश्यक';

  @override
  String get forceUpdateMessage =>
      'एक नया संस्करण उपलब्ध है। जारी रखने के लिए कृपया अपडेट करें।';

  @override
  String get forceUpdateButton => 'अभी अपडेट करें';
}
