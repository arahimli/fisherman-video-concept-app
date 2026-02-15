part of 'bloc.dart';

abstract class VideoState {}

class VideoInitial extends VideoState {}

class ImagePickedState extends VideoState {
  final File imageFile;
  ImagePickedState(this.imageFile);
}

class VideoLoadingState extends VideoState {
  final File imageFile;
  final String loadingMessage;
  VideoLoadingState(this.imageFile, this.loadingMessage);
}

class VideoGeneratedState extends VideoState {
  final File imageFile;
  final String videoPath;
  VideoGeneratedState(this.imageFile, this.videoPath);
}

class VideoErrorState extends VideoState {
  final File? imageFile;
  final String errorMessage;
  VideoErrorState(this.errorMessage, {this.imageFile});
}