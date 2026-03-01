// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Old Fisherman';

  @override
  String get create => 'CREATE';

  @override
  String get selectImage => 'SELECT\nIMAGE';

  @override
  String get changeImage => 'CHANGE\nIMAGE';

  @override
  String get generateVideo => 'GENERATE\nVIDEO';

  @override
  String get videoReady => 'VIDEO READY';

  @override
  String get previewVideo => 'PREVIEW VIDEO';

  @override
  String get recentVideos => 'RECENT VIDEOS';

  @override
  String get viewAll => 'VIEW ALL';

  @override
  String get history => 'History';

  @override
  String get allVideos => 'All Videos';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get older => 'Older';

  @override
  String get noVideos => 'No videos yet';

  @override
  String get noVideosDesc => 'Create your first video to see it here';

  @override
  String get deleteVideo => 'Delete Video';

  @override
  String get deleteConfirm => 'Are you sure you want to delete this video?';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get resetConfirmTitle => 'Reset';

  @override
  String get resetConfirmMessage => 'Do you want to reset all changes?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get imageProcessing => 'Processing image...';

  @override
  String get videoGenerating => 'Generating video...';

  @override
  String get videoGenerated => 'Video generated ✓';

  @override
  String get videoGenerationError => 'Error occurred while generating video';

  @override
  String get selectImageFirst => 'Please select an image first';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get allDates => 'All Dates';

  @override
  String get loadMore => 'Load More';

  @override
  String videosCount(int count) {
    return '$count videos';
  }

  @override
  String get videoPreviewTitle => 'PREVIEW';

  @override
  String get shareSheet => 'SHARE';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get saveToGalleryDesc => 'Will be saved to your phone\'s gallery';

  @override
  String get videoSavedSuccess => '✓ Video saved to gallery';

  @override
  String get share => 'Share';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram and other apps';

  @override
  String get shareVideoText => 'Look at my video!';

  @override
  String get selectFromGallery => 'Choose from your photo library';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get takePhotoDesc => 'Open camera and take a new photo';

  @override
  String shareError(Object error) {
    return 'Share error: $error';
  }

  @override
  String get settings => 'Settings';

  @override
  String get watermark => 'Watermark';

  @override
  String get imageWatermark => 'Image Watermark';

  @override
  String get imageWatermarkDesc => 'Overlay a logo or image on the video';

  @override
  String get watermarkPosition => 'Watermark Position';

  @override
  String get watermarkHint =>
      'Disable the watermark to create videos without any overlay.';

  @override
  String get watermarkChangeImage => 'Change Image';

  @override
  String get watermarkRemove => 'Remove';

  @override
  String get watermarkSelectImage => 'Select Image';

  @override
  String get positionTopLeft => 'Top Left';

  @override
  String get positionTopRight => 'Top Right';

  @override
  String get positionBottomLeft => 'Bottom Left';

  @override
  String get positionBottomRight => 'Bottom Right';

  @override
  String get backToSelectImageTitle => 'Go Back';

  @override
  String get backToSelectImageMessage =>
      'Are you sure you want to go back to select image mode?';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get support => 'Support';

  @override
  String get supportDesc =>
      'Watch a video ad to help keep the app free and support development';

  @override
  String get shortVideo => 'Short Video';

  @override
  String get shortVideoDesc => 'Watch a short ad to support the app';

  @override
  String get longVideo => 'Long Video';

  @override
  String get longVideoDesc => 'Watch a longer ad for extra support';

  @override
  String get watchAd => 'Watch';

  @override
  String get thankYouSupport => 'Thank you for your support!';

  @override
  String get adsWatched => 'Ads Watched';

  @override
  String get adsWatchedToday => 'Today';

  @override
  String get adsWatchedTotal => 'Total';

  @override
  String get selectVideoLanguage => 'Select Language';

  @override
  String get englishVoice => 'English';

  @override
  String get englishVoiceDesc => 'Generate video with English narration';

  @override
  String get turkishVoice => 'Turkish';

  @override
  String get turkishVoiceDesc => 'Generate video with Turkish narration';

  @override
  String get russianVoice => 'Russian';

  @override
  String get russianVoiceDesc => 'Generate video with Russian narration';

  @override
  String get frenchVoice => 'French';

  @override
  String get frenchVoiceDesc => 'Generate video with French narration';

  @override
  String get arabicVoice => 'Arabic';

  @override
  String get arabicVoiceDesc => 'Generate video with Arabic narration';

  @override
  String get chineseVoice => 'Chinese';

  @override
  String get chineseVoiceDesc =>
      'Generate video with Mandarin Chinese narration';

  @override
  String get spanishVoice => 'Spanish';

  @override
  String get spanishVoiceDesc => 'Generate video with Spanish narration';

  @override
  String get hindiVoice => 'Hindi';

  @override
  String get hindiVoiceDesc => 'Generate video with Hindi narration';
}
