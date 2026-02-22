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
}
