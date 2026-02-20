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
  String get history => 'История';

  @override
  String get allVideos => 'Все видео';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get older => 'Старые';

  @override
  String get noVideos => 'Видео пока нет';

  @override
  String get noVideosDesc => 'Создайте первое видео, чтобы оно появилось здесь';

  @override
  String get deleteVideo => 'Удалить видео';

  @override
  String get deleteConfirm => 'Вы уверены, что хотите удалить это видео?';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

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
  String get filterByDate => 'Фильтр по дате';

  @override
  String get allDates => 'Все даты';

  @override
  String get loadMore => 'Загрузить ещё';

  @override
  String videosCount(int count) {
    return '$count видео';
  }

  @override
  String get videoPreviewTitle => 'ПРОСМОТР';

  @override
  String get shareSheet => 'ПОДЕЛИТЬСЯ';

  @override
  String get save => 'Сохранить';

  @override
  String get saving => 'Сохранение...';

  @override
  String get saveToGallery => 'Сохранить в галерею';

  @override
  String get saveToGalleryDesc => 'Будет сохранено в галерею телефона';

  @override
  String get videoSavedSuccess => '✓ Видео сохранено в галерею';

  @override
  String get share => 'Поделиться';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram и другие приложения';

  @override
  String get shareVideoText => 'Посмотри моё видео!';

  @override
  String shareError(Object error) => 'Ошибка при отправке: $error';
}
