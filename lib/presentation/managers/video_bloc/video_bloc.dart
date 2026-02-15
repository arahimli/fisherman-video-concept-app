

part of 'bloc.dart';


class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final ImagePicker _picker = ImagePicker();

  VideoBloc() : super(VideoInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<GenerateVideoEvent>(_onGenerateVideo);
    on<ResetEvent>(_onReset);
  }

  Future<void> _onPickImage(
      PickImageEvent event,
      Emitter<VideoState> emit,
      ) async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        emit(ImagePickedState(File(picked.path)));
      }
    } catch (e) {
      emit(VideoErrorState('Image selection error: $e'));
    }
  }

  Future<void> _onGenerateVideo(
      GenerateVideoEvent event,
      Emitter<VideoState> emit,
      ) async {
    if (state is! ImagePickedState && state is! VideoErrorState) {
      emit(VideoErrorState('Please select an image first'));
      return;
    }

    File? imageFile;
    if (state is ImagePickedState) {
      imageFile = (state as ImagePickedState).imageFile;
    } else if (state is VideoErrorState) {
      imageFile = (state as VideoErrorState).imageFile;
    }

    if (imageFile == null) {
      emit(VideoErrorState('Image not found'));
      return;
    }

    try {
      // Processing image - message will be localized in UI
      emit(VideoLoadingState(imageFile, event.processingMessage ?? 'Processing image...'));
      final images = await ImageService.processImage(imageFile);

      // Generating video - message will be localized in UI
      emit(VideoLoadingState(imageFile, event.generatingMessage ?? 'Generating video...'));
      final videoFile = await VideoService.generateVideo(images);

      if (videoFile != null) {
        emit(VideoGeneratedState(imageFile, videoFile));
      } else {
        emit(VideoErrorState(
          'Video generation error',
          imageFile: imageFile,
        ));
      }
    } catch (e) {
      emit(VideoErrorState(
        'Error: $e',
        imageFile: imageFile,
      ));
    }
  }

  Future<void> _onReset(
      ResetEvent event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoInitial());
  }
}