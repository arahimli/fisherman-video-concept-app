// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vogue Motion';

  @override
  String get create => 'CREATE';

  @override
  String get selectImage => 'SELECT IMAGE';

  @override
  String get changeImage => 'CHANGE IMAGE';

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
  String error(String error) {
    return 'Error: $error';
  }
}
