part of 'bloc.dart';

abstract class VideoEvent {}

class PickImageEvent extends VideoEvent {}

class GenerateVideoEvent extends VideoEvent {
  final String? processingMessage;
  final String? generatingMessage;

  GenerateVideoEvent({
    this.processingMessage,
    this.generatingMessage,
  });
}

class ResetEvent extends VideoEvent {}

class VideoPreviewRequestedEvent extends VideoEvent {
  final String videoPath;
  VideoPreviewRequestedEvent(this.videoPath);
}