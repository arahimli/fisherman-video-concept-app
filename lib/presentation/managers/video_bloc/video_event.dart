part of 'bloc.dart';

abstract class VideoEvent {}

class PickImageEvent extends VideoEvent {
  final ImageSource source;
  PickImageEvent({this.source = ImageSource.gallery});
}

class GenerateVideoEvent extends VideoEvent {
  final String? processingMessage;
  final String? generatingMessage;
  final VideoLanguage language;

  GenerateVideoEvent({
    this.processingMessage,
    this.generatingMessage,
    this.language = VideoLanguage.en,
  });
}

class ResetEvent extends VideoEvent {}

class VideoPreviewRequestedEvent extends VideoEvent {
  final String videoPath;
  VideoPreviewRequestedEvent(this.videoPath);
}