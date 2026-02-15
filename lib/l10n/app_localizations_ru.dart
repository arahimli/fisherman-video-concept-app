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
  String error(String error) {
    return 'Ошибка: $error';
  }
}
