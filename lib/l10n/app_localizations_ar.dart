// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الصياد العجوز';

  @override
  String get create => 'إنشاء';

  @override
  String get selectImage => 'اختر\nصورة';

  @override
  String get changeImage => 'تغيير\nالصورة';

  @override
  String get generateVideo => 'إنشاء\nفيديو';

  @override
  String get videoReady => 'الفيديو جاهز';

  @override
  String get previewVideo => 'معاينة الفيديو';

  @override
  String get recentVideos => 'مقاطع الفيديو الأخيرة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get history => 'السجل';

  @override
  String get allVideos => 'كل مقاطع الفيديو';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get older => 'أقدم';

  @override
  String get noVideos => 'لا توجد مقاطع فيديو بعد';

  @override
  String get noVideosDesc => 'أنشئ أول فيديو لك لرؤيته هنا';

  @override
  String get deleteVideo => 'حذف الفيديو';

  @override
  String get deleteConfirm => 'هل أنت متأكد أنك تريد حذف هذا الفيديو؟';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get resetConfirmTitle => 'إعادة تعيين';

  @override
  String get resetConfirmMessage => 'هل تريد إعادة تعيين جميع التغييرات؟';

  @override
  String get no => 'لا';

  @override
  String get yes => 'نعم';

  @override
  String get imageProcessing => 'جاري معالجة الصورة...';

  @override
  String get videoGenerating => 'جاري إنشاء الفيديو...';

  @override
  String get videoGenerated => 'تم إنشاء الفيديو ✓';

  @override
  String get videoGenerationError => 'حدث خطأ أثناء إنشاء الفيديو';

  @override
  String get selectImageFirst => 'يرجى اختيار صورة أولاً';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get filterByDate => 'تصفية حسب التاريخ';

  @override
  String get allDates => 'جميع التواريخ';

  @override
  String get allLanguages => 'الكل';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String videosCount(int count) {
    return '$count مقاطع فيديو';
  }

  @override
  String get videoPreviewTitle => 'معاينة';

  @override
  String get shareSheet => 'مشاركة';

  @override
  String get save => 'حفظ';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get saveToGallery => 'حفظ في المعرض';

  @override
  String get saveToGalleryDesc => 'سيتم الحفظ في معرض هاتفك';

  @override
  String get videoSavedSuccess => '✓ تم حفظ الفيديو في المعرض';

  @override
  String get share => 'مشاركة';

  @override
  String get shareSubtitle => 'واتساب وتيليغرام وتطبيقات أخرى';

  @override
  String get shareVideoText => 'انظر إلى الفيديو الخاص بي!';

  @override
  String get selectFromGallery => 'اختر من مكتبة الصور';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get takePhotoDesc => 'افتح الكاميرا والتقط صورة جديدة';

  @override
  String shareError(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get watermark => 'العلامة المائية';

  @override
  String get imageWatermark => 'علامة مائية للصورة';

  @override
  String get imageWatermarkDesc => 'إضافة شعار أو صورة فوق الفيديو';

  @override
  String get watermarkPosition => 'موضع العلامة المائية';

  @override
  String get watermarkHint =>
      'قم بتعطيل العلامة المائية لإنشاء مقاطع فيديو بدون أي تراكب.';

  @override
  String get watermarkChangeImage => 'تغيير الصورة';

  @override
  String get watermarkRemove => 'إزالة';

  @override
  String get watermarkSelectImage => 'اختيار صورة';

  @override
  String get positionTopLeft => 'أعلى اليسار';

  @override
  String get positionTopRight => 'أعلى اليمين';

  @override
  String get positionBottomLeft => 'أسفل اليسار';

  @override
  String get positionBottomRight => 'أسفل اليمين';

  @override
  String get backToSelectImageTitle => 'الرجوع';

  @override
  String get backToSelectImageMessage =>
      'هل أنت متأكد أنك تريد العودة إلى وضع اختيار الصورة؟';

  @override
  String get pressBackAgainToExit => 'اضغط على رجوع مرة أخرى للخروج';

  @override
  String get support => 'الدعم';

  @override
  String get supportDesc =>
      'شاهد إعلاناً لمساعدتنا في إبقاء التطبيق مجانياً ودعم التطوير';

  @override
  String get shortVideo => 'فيديو قصير';

  @override
  String get shortVideoDesc => 'شاهد إعلاناً قصيراً لدعم التطبيق';

  @override
  String get longVideo => 'فيديو طويل';

  @override
  String get longVideoDesc => 'شاهد إعلاناً أطول لدعم إضافي';

  @override
  String get watchAd => 'مشاهدة';

  @override
  String get thankYouSupport => 'شكراً لدعمك!';

  @override
  String get adsWatched => 'الإعلانات المُشاهدة';

  @override
  String get adsWatchedToday => 'اليوم';

  @override
  String get adsWatchedTotal => 'الإجمالي';

  @override
  String get selectVideoLanguage => 'اختيار اللغة';

  @override
  String get englishVoice => 'الإنجليزية';

  @override
  String get englishVoiceDesc => 'إنشاء فيديو بسرد باللغة الإنجليزية';

  @override
  String get turkishVoice => 'التركية';

  @override
  String get turkishVoiceDesc => 'إنشاء فيديو بسرد باللغة التركية';

  @override
  String get russianVoice => 'الروسية';

  @override
  String get russianVoiceDesc => 'إنشاء فيديو بسرد باللغة الروسية';

  @override
  String get frenchVoice => 'الفرنسية';

  @override
  String get frenchVoiceDesc => 'إنشاء فيديو بسرد باللغة الفرنسية';

  @override
  String get arabicVoice => 'العربية';

  @override
  String get arabicVoiceDesc => 'إنشاء فيديو بسرد باللغة العربية';

  @override
  String get chineseVoice => 'الصينية';

  @override
  String get chineseVoiceDesc => 'إنشاء فيديو بسرد باللغة الصينية الماندرين';

  @override
  String get spanishVoice => 'الإسبانية';

  @override
  String get spanishVoiceDesc => 'إنشاء فيديو بسرد باللغة الإسبانية';

  @override
  String get hindiVoice => 'الهندية';

  @override
  String get hindiVoiceDesc => 'إنشاء فيديو بسرد باللغة الهندية';

  @override
  String get home => 'الرئيسية';

  @override
  String get appLanguage => 'اللغة';

  @override
  String get forceUpdateTitle => 'تحديث مطلوب';

  @override
  String get forceUpdateMessage => 'يتوفر إصدار جديد. يرجى التحديث للمتابعة.';

  @override
  String get forceUpdateButton => 'تحديث الآن';
}
