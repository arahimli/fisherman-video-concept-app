// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Vogue Motion';

  @override
  String get create => 'СОЗДАТЬ';

  @override
  String get selectImage => 'ВЫБРАТЬ ФОТО';

  @override
  String get changeImage => 'ИЗМЕНИТЬ ФОТО';

  @override
  String get generateVideo => 'СОЗДАТЬ\nВИДЕО';

  @override
  String get videoReady => 'ВИДЕО ГОТОВО';

  @override
  String get previewVideo => 'ПРОСМОТР ВИДЕО';

  @override
  String get recentVideos => 'ПОСЛЕДНИЕ ВИДЕО';

  @override
  String get viewAll => 'ВСЕ';

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
  String get reset => 'Сбросить';

  @override
  String get resetConfirmTitle => 'Сбросить';

  @override
  String get resetConfirmMessage => 'Вы хотите сбросить все изменения?';

  @override
  String get no => 'Нет';

  @override
  String get yes => 'Да';

  @override
  String get imageProcessing => 'Обработка изображения...';

  @override
  String get videoGenerating => 'Создание видео...';

  @override
  String get videoGenerated => 'Видео готово ✓';

  @override
  String get videoGenerationError => 'Произошла ошибка при создании видео';

  @override
  String get selectImageFirst => 'Сначала выберите изображение';

  @override
  String error(Object error) {
    return 'Ошибка: $error';
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
}
