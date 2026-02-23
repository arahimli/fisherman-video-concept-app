import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('en'),
    Locale('ru'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Old Fisherman'**
  String get appTitle;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get create;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'SELECT\nIMAGE'**
  String get selectImage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'CHANGE\nIMAGE'**
  String get changeImage;

  /// No description provided for @generateVideo.
  ///
  /// In en, this message translates to:
  /// **'GENERATE\nVIDEO'**
  String get generateVideo;

  /// No description provided for @videoReady.
  ///
  /// In en, this message translates to:
  /// **'VIDEO READY'**
  String get videoReady;

  /// No description provided for @previewVideo.
  ///
  /// In en, this message translates to:
  /// **'PREVIEW VIDEO'**
  String get previewVideo;

  /// No description provided for @recentVideos.
  ///
  /// In en, this message translates to:
  /// **'RECENT VIDEOS'**
  String get recentVideos;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewAll;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @allVideos.
  ///
  /// In en, this message translates to:
  /// **'All Videos'**
  String get allVideos;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @older.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get older;

  /// No description provided for @noVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos yet'**
  String get noVideos;

  /// No description provided for @noVideosDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first video to see it here'**
  String get noVideosDesc;

  /// No description provided for @deleteVideo.
  ///
  /// In en, this message translates to:
  /// **'Delete Video'**
  String get deleteVideo;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this video?'**
  String get deleteConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset all changes?'**
  String get resetConfirmMessage;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @imageProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get imageProcessing;

  /// No description provided for @videoGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating video...'**
  String get videoGenerating;

  /// No description provided for @videoGenerated.
  ///
  /// In en, this message translates to:
  /// **'Video generated ✓'**
  String get videoGenerated;

  /// No description provided for @videoGenerationError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred while generating video'**
  String get videoGenerationError;

  /// No description provided for @selectImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an image first'**
  String get selectImageFirst;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All Dates'**
  String get allDates;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @videosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} videos'**
  String videosCount(int count);

  /// No description provided for @videoPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get videoPreviewTitle;

  /// No description provided for @shareSheet.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get shareSheet;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @saveToGalleryDesc.
  ///
  /// In en, this message translates to:
  /// **'Will be saved to your phone\'s gallery'**
  String get saveToGalleryDesc;

  /// No description provided for @videoSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'✓ Video saved to gallery'**
  String get videoSavedSuccess;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp, Telegram and other apps'**
  String get shareSubtitle;

  /// No description provided for @shareVideoText.
  ///
  /// In en, this message translates to:
  /// **'Look at my video!'**
  String get shareVideoText;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from your photo library'**
  String get selectFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @takePhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'Open camera and take a new photo'**
  String get takePhotoDesc;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Share error: {error}'**
  String shareError(Object error);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @watermark.
  ///
  /// In en, this message translates to:
  /// **'Watermark'**
  String get watermark;

  /// No description provided for @imageWatermark.
  ///
  /// In en, this message translates to:
  /// **'Image Watermark'**
  String get imageWatermark;

  /// No description provided for @imageWatermarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Overlay a logo or image on the video'**
  String get imageWatermarkDesc;

  /// No description provided for @watermarkPosition.
  ///
  /// In en, this message translates to:
  /// **'Watermark Position'**
  String get watermarkPosition;

  /// No description provided for @watermarkHint.
  ///
  /// In en, this message translates to:
  /// **'Disable the watermark to create videos without any overlay.'**
  String get watermarkHint;

  /// No description provided for @watermarkChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get watermarkChangeImage;

  /// No description provided for @watermarkRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get watermarkRemove;

  /// No description provided for @watermarkSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get watermarkSelectImage;

  /// No description provided for @positionTopLeft.
  ///
  /// In en, this message translates to:
  /// **'Top Left'**
  String get positionTopLeft;

  /// No description provided for @positionTopRight.
  ///
  /// In en, this message translates to:
  /// **'Top Right'**
  String get positionTopRight;

  /// No description provided for @positionBottomLeft.
  ///
  /// In en, this message translates to:
  /// **'Bottom Left'**
  String get positionBottomLeft;

  /// No description provided for @positionBottomRight.
  ///
  /// In en, this message translates to:
  /// **'Bottom Right'**
  String get positionBottomRight;

  /// No description provided for @backToSelectImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get backToSelectImageTitle;

  /// No description provided for @backToSelectImageMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to go back to select image mode?'**
  String get backToSelectImageMessage;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch a video ad to help keep the app free and support development'**
  String get supportDesc;

  /// No description provided for @shortVideo.
  ///
  /// In en, this message translates to:
  /// **'Short Video'**
  String get shortVideo;

  /// No description provided for @shortVideoDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to support the app'**
  String get shortVideoDesc;

  /// No description provided for @longVideo.
  ///
  /// In en, this message translates to:
  /// **'Long Video'**
  String get longVideo;

  /// No description provided for @longVideoDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch a longer ad for extra support'**
  String get longVideoDesc;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watchAd;

  /// No description provided for @thankYouSupport.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support!'**
  String get thankYouSupport;

  /// No description provided for @adsWatched.
  ///
  /// In en, this message translates to:
  /// **'Ads Watched'**
  String get adsWatched;

  /// No description provided for @adsWatchedToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get adsWatchedToday;

  /// No description provided for @adsWatchedTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get adsWatchedTotal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'en', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
