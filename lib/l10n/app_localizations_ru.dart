// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Old Fisherman';

  @override
  String get create => 'СОЗДАТЬ';

  @override
  String get selectImage => 'ВЫБРАТЬ\nФОТО';

  @override
  String get changeImage => 'ИЗМЕНИТЬ\nФОТО';

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
  String get allLanguages => 'Все';

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
  String get selectFromGallery => 'Выбрать из библиотеки';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get takePhotoDesc => 'Открыть камеру и сделать новое фото';

  @override
  String shareError(Object error) {
    return 'Ошибка при отправке: $error';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get watermark => 'Водяной знак';

  @override
  String get imageWatermark => 'Изображение-водяной знак';

  @override
  String get imageWatermarkDesc => 'Наложить логотип или изображение на видео';

  @override
  String get watermarkPosition => 'Положение водяного знака';

  @override
  String get watermarkHint =>
      'Отключите водяной знак, чтобы создать видео без наложения.';

  @override
  String get watermarkChangeImage => 'Изменить изображение';

  @override
  String get watermarkRemove => 'Удалить';

  @override
  String get watermarkSelectImage => 'Выбрать изображение';

  @override
  String get positionTopLeft => 'Верх слева';

  @override
  String get positionTopRight => 'Верх справа';

  @override
  String get positionBottomLeft => 'Низ слева';

  @override
  String get positionBottomRight => 'Низ справа';

  @override
  String get backToSelectImageTitle => 'Назад';

  @override
  String get backToSelectImageMessage =>
      'Вы уверены, что хотите вернуться к выбору изображения?';

  @override
  String get pressBackAgainToExit => 'Нажмите ещё раз для выхода';

  @override
  String get support => 'Поддержка';

  @override
  String get supportDesc =>
      'Посмотрите видеорекламу, чтобы помочь сохранить приложение бесплатным';

  @override
  String get shortVideo => 'Короткое видео';

  @override
  String get shortVideoDesc => 'Посмотрите короткую рекламу для поддержки';

  @override
  String get longVideo => 'Длинное видео';

  @override
  String get longVideoDesc =>
      'Посмотрите длинную рекламу для дополнительной поддержки';

  @override
  String get watchAd => 'Смотреть';

  @override
  String get thankYouSupport => 'Спасибо за вашу поддержку!';

  @override
  String get adsWatched => 'Просмотрено реклам';

  @override
  String get adsWatchedToday => 'Сегодня';

  @override
  String get adsWatchedTotal => 'Всего';

  @override
  String get selectVideoLanguage => 'Выберите язык';

  @override
  String get englishVoice => 'Английский';

  @override
  String get englishVoiceDesc => 'Создать видео с английским озвучиванием';

  @override
  String get turkishVoice => 'Турецкий';

  @override
  String get turkishVoiceDesc => 'Создать видео с турецким озвучиванием';

  @override
  String get russianVoice => 'Русский';

  @override
  String get russianVoiceDesc => 'Создать видео с русским озвучиванием';

  @override
  String get frenchVoice => 'Французский';

  @override
  String get frenchVoiceDesc => 'Создать видео с французским озвучиванием';

  @override
  String get arabicVoice => 'Арабский';

  @override
  String get arabicVoiceDesc => 'Создать видео с арабским озвучиванием';

  @override
  String get chineseVoice => 'Китайский';

  @override
  String get chineseVoiceDesc =>
      'Создать видео с озвучиванием на мандаринском китайском';

  @override
  String get spanishVoice => 'Испанский';

  @override
  String get spanishVoiceDesc => 'Создать видео с испанским озвучиванием';

  @override
  String get hindiVoice => 'Хинди';

  @override
  String get hindiVoiceDesc => 'Создать видео с озвучиванием на хинди';

  @override
  String get appLanguage => 'Язык';

  @override
  String get forceUpdateTitle => 'Требуется обновление';

  @override
  String get forceUpdateMessage =>
      'Доступна новая версия. Обновите приложение, чтобы продолжить.';

  @override
  String get forceUpdateButton => 'ОБНОВИТЬ';
}
