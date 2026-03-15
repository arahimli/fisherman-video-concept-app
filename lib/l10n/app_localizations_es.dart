// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Viejo Pescador';

  @override
  String get create => 'CREAR';

  @override
  String get selectImage => 'SELECCIONAR\nIMAGEN';

  @override
  String get changeImage => 'CAMBIAR\nIMAGEN';

  @override
  String get generateVideo => 'GENERAR\nVIDEO';

  @override
  String get videoReady => 'VIDEO LISTO';

  @override
  String get previewVideo => 'VISTA PREVIA';

  @override
  String get recentVideos => 'VIDEOS RECIENTES';

  @override
  String get viewAll => 'VER TODO';

  @override
  String get history => 'Historial';

  @override
  String get allVideos => 'Todos los Videos';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get older => 'Más Antiguo';

  @override
  String get noVideos => 'Sin videos todavía';

  @override
  String get noVideosDesc => 'Crea tu primer video para verlo aquí';

  @override
  String get deleteVideo => 'Eliminar Video';

  @override
  String get deleteConfirm =>
      '¿Estás seguro de que quieres eliminar este video?';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Restablecer';

  @override
  String get resetConfirmTitle => 'Restablecer';

  @override
  String get resetConfirmMessage => '¿Quieres restablecer todos los cambios?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get imageProcessing => 'Procesando imagen...';

  @override
  String get videoGenerating => 'Generando video...';

  @override
  String get videoGenerated => 'Video generado ✓';

  @override
  String get videoGenerationError => 'Error al generar el video';

  @override
  String get selectImageFirst => 'Por favor selecciona una imagen primero';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get filterByDate => 'Filtrar por Fecha';

  @override
  String get allDates => 'Todas las Fechas';

  @override
  String get allLanguages => 'Todos';

  @override
  String get loadMore => 'Cargar Más';

  @override
  String videosCount(int count) {
    return '$count videos';
  }

  @override
  String get videoPreviewTitle => 'VISTA PREVIA';

  @override
  String get shareSheet => 'COMPARTIR';

  @override
  String get save => 'Guardar';

  @override
  String get saving => 'Guardando...';

  @override
  String get saveToGallery => 'Guardar en galería';

  @override
  String get saveToGalleryDesc => 'Se guardará en la galería de tu teléfono';

  @override
  String get videoSavedSuccess => '✓ Video guardado en la galería';

  @override
  String get share => 'Compartir';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram y otras apps';

  @override
  String get shareVideoText => '¡Mira mi video!';

  @override
  String get selectFromGallery => 'Elige de tu biblioteca de fotos';

  @override
  String get takePhoto => 'Tomar Foto';

  @override
  String get takePhotoDesc => 'Abrir la cámara y tomar una nueva foto';

  @override
  String shareError(Object error) {
    return 'Error al compartir: $error';
  }

  @override
  String get settings => 'Configuración';

  @override
  String get watermark => 'Marca de Agua';

  @override
  String get imageWatermark => 'Marca de Agua de Imagen';

  @override
  String get imageWatermarkDesc => 'Superponer un logo o imagen en el video';

  @override
  String get watermarkPosition => 'Posición de Marca de Agua';

  @override
  String get watermarkHint =>
      'Desactiva la marca de agua para crear videos sin superposición.';

  @override
  String get watermarkChangeImage => 'Cambiar Imagen';

  @override
  String get watermarkRemove => 'Eliminar';

  @override
  String get watermarkSelectImage => 'Seleccionar Imagen';

  @override
  String get positionTopLeft => 'Arriba Izquierda';

  @override
  String get positionTopRight => 'Arriba Derecha';

  @override
  String get positionBottomLeft => 'Abajo Izquierda';

  @override
  String get positionBottomRight => 'Abajo Derecha';

  @override
  String get backToSelectImageTitle => 'Volver';

  @override
  String get backToSelectImageMessage =>
      '¿Estás seguro de que quieres volver al modo de selección de imagen?';

  @override
  String get pressBackAgainToExit => 'Presiona atrás de nuevo para salir';

  @override
  String get support => 'Soporte';

  @override
  String get supportDesc =>
      'Mira un anuncio de video para ayudar a mantener la app gratuita y apoyar el desarrollo';

  @override
  String get shortVideo => 'Video Corto';

  @override
  String get shortVideoDesc => 'Mira un anuncio corto para apoyar la app';

  @override
  String get longVideo => 'Video Largo';

  @override
  String get longVideoDesc => 'Mira un anuncio más largo para soporte extra';

  @override
  String get watchAd => 'Ver';

  @override
  String get thankYouSupport => '¡Gracias por tu apoyo!';

  @override
  String get adsWatched => 'Anuncios Vistos';

  @override
  String get adsWatchedToday => 'Hoy';

  @override
  String get adsWatchedTotal => 'Total';

  @override
  String get selectVideoLanguage => 'Seleccionar Idioma';

  @override
  String get englishVoice => 'Inglés';

  @override
  String get englishVoiceDesc => 'Generar video con narración en inglés';

  @override
  String get turkishVoice => 'Turco';

  @override
  String get turkishVoiceDesc => 'Generar video con narración en turco';

  @override
  String get russianVoice => 'Ruso';

  @override
  String get russianVoiceDesc => 'Generar video con narración en ruso';

  @override
  String get frenchVoice => 'Francés';

  @override
  String get frenchVoiceDesc => 'Generar video con narración en francés';

  @override
  String get arabicVoice => 'Árabe';

  @override
  String get arabicVoiceDesc => 'Generar video con narración en árabe';

  @override
  String get chineseVoice => 'Chino';

  @override
  String get chineseVoiceDesc =>
      'Generar video con narración en chino mandarín';

  @override
  String get spanishVoice => 'Español';

  @override
  String get spanishVoiceDesc => 'Generar video con narración en español';

  @override
  String get hindiVoice => 'Hindi';

  @override
  String get hindiVoiceDesc => 'Generar video con narración en hindi';

  @override
  String get appLanguage => 'Idioma';

  @override
  String get forceUpdateTitle => 'Actualización Requerida';

  @override
  String get forceUpdateMessage =>
      'Una nueva versión está disponible. Por favor actualiza para continuar.';

  @override
  String get forceUpdateButton => 'ACTUALIZAR AHORA';
}
