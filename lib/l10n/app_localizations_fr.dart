// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vieux Pêcheur';

  @override
  String get create => 'CRÉER';

  @override
  String get selectImage => 'SÉLECTIONNER\nUNE IMAGE';

  @override
  String get changeImage => 'CHANGER\nL\'IMAGE';

  @override
  String get generateVideo => 'GÉNÉRER\nUNE VIDÉO';

  @override
  String get videoReady => 'VIDÉO PRÊTE';

  @override
  String get previewVideo => 'APERÇU DE LA VIDÉO';

  @override
  String get recentVideos => 'VIDÉOS RÉCENTES';

  @override
  String get viewAll => 'TOUT VOIR';

  @override
  String get history => 'Historique';

  @override
  String get allVideos => 'Toutes les Vidéos';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get thisWeek => 'Cette Semaine';

  @override
  String get thisMonth => 'Ce Mois';

  @override
  String get older => 'Plus Ancien';

  @override
  String get noVideos => 'Aucune vidéo pour l\'instant';

  @override
  String get noVideosDesc => 'Créez votre première vidéo pour la voir ici';

  @override
  String get deleteVideo => 'Supprimer la Vidéo';

  @override
  String get deleteConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette vidéo ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetConfirmTitle => 'Réinitialiser';

  @override
  String get resetConfirmMessage =>
      'Voulez-vous réinitialiser toutes les modifications ?';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get imageProcessing => 'Traitement de l\'image...';

  @override
  String get videoGenerating => 'Génération de la vidéo...';

  @override
  String get videoGenerated => 'Vidéo générée ✓';

  @override
  String get videoGenerationError =>
      'Erreur lors de la génération de la vidéo';

  @override
  String get selectImageFirst => 'Veuillez d\'abord sélectionner une image';

  @override
  String error(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get filterByDate => 'Filtrer par Date';

  @override
  String get allDates => 'Toutes les Dates';

  @override
  String get allLanguages => 'Tous';

  @override
  String get loadMore => 'Charger Plus';

  @override
  String videosCount(int count) {
    return '$count vidéos';
  }

  @override
  String get videoPreviewTitle => 'APERÇU';

  @override
  String get shareSheet => 'PARTAGER';

  @override
  String get save => 'Enregistrer';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get saveToGallery => 'Enregistrer dans la galerie';

  @override
  String get saveToGalleryDesc =>
      'Sera enregistré dans la galerie de votre téléphone';

  @override
  String get videoSavedSuccess => '✓ Vidéo enregistrée dans la galerie';

  @override
  String get share => 'Partager';

  @override
  String get shareSubtitle => 'WhatsApp, Telegram et autres applications';

  @override
  String get shareVideoText => 'Regardez ma vidéo !';

  @override
  String get selectFromGallery => 'Choisir dans votre photothèque';

  @override
  String get takePhoto => 'Prendre une Photo';

  @override
  String get takePhotoDesc => 'Ouvrir la caméra et prendre une nouvelle photo';

  @override
  String shareError(Object error) {
    return 'Erreur de partage : $error';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get watermark => 'Filigrane';

  @override
  String get imageWatermark => 'Filigrane d\'Image';

  @override
  String get imageWatermarkDesc =>
      'Superposer un logo ou une image sur la vidéo';

  @override
  String get watermarkPosition => 'Position du Filigrane';

  @override
  String get watermarkHint =>
      'Désactivez le filigrane pour créer des vidéos sans superposition.';

  @override
  String get watermarkChangeImage => 'Changer l\'Image';

  @override
  String get watermarkRemove => 'Supprimer';

  @override
  String get watermarkSelectImage => 'Sélectionner l\'Image';

  @override
  String get positionTopLeft => 'En Haut à Gauche';

  @override
  String get positionTopRight => 'En Haut à Droite';

  @override
  String get positionBottomLeft => 'En Bas à Gauche';

  @override
  String get positionBottomRight => 'En Bas à Droite';

  @override
  String get backToSelectImageTitle => 'Retour';

  @override
  String get backToSelectImageMessage =>
      'Êtes-vous sûr de vouloir revenir au mode de sélection d\'image ?';

  @override
  String get pressBackAgainToExit =>
      'Appuyez à nouveau sur Retour pour quitter';

  @override
  String get support => 'Soutien';

  @override
  String get supportDesc =>
      'Regardez une publicité vidéo pour aider à garder l\'application gratuite et soutenir le développement';

  @override
  String get shortVideo => 'Vidéo Courte';

  @override
  String get shortVideoDesc =>
      'Regardez une courte publicité pour soutenir l\'application';

  @override
  String get longVideo => 'Vidéo Longue';

  @override
  String get longVideoDesc =>
      'Regardez une publicité plus longue pour un soutien supplémentaire';

  @override
  String get watchAd => 'Regarder';

  @override
  String get thankYouSupport => 'Merci pour votre soutien !';

  @override
  String get adsWatched => 'Publicités Vues';

  @override
  String get adsWatchedToday => 'Aujourd\'hui';

  @override
  String get adsWatchedTotal => 'Total';

  @override
  String get selectVideoLanguage => 'Sélectionner la Langue';

  @override
  String get englishVoice => 'Anglais';

  @override
  String get englishVoiceDesc =>
      'Générer une vidéo avec narration en anglais';

  @override
  String get turkishVoice => 'Turc';

  @override
  String get turkishVoiceDesc => 'Générer une vidéo avec narration en turc';

  @override
  String get russianVoice => 'Russe';

  @override
  String get russianVoiceDesc => 'Générer une vidéo avec narration en russe';

  @override
  String get frenchVoice => 'Français';

  @override
  String get frenchVoiceDesc =>
      'Générer une vidéo avec narration en français';

  @override
  String get arabicVoice => 'Arabe';

  @override
  String get arabicVoiceDesc => 'Générer une vidéo avec narration en arabe';

  @override
  String get chineseVoice => 'Chinois';

  @override
  String get chineseVoiceDesc =>
      'Générer une vidéo avec narration en chinois mandarin';

  @override
  String get spanishVoice => 'Espagnol';

  @override
  String get spanishVoiceDesc =>
      'Générer une vidéo avec narration en espagnol';

  @override
  String get hindiVoice => 'Hindi';

  @override
  String get hindiVoiceDesc => 'Générer une vidéo avec narration en hindi';

  @override
  String get forceUpdateTitle => 'Mise à Jour Requise';

  @override
  String get forceUpdateMessage =>
      'Une nouvelle version est disponible. Veuillez mettre à jour pour continuer.';

  @override
  String get forceUpdateButton => 'METTRE À JOUR';
}
