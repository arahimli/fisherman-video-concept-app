

part of 'bloc.dart';



class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final ImagePicker _picker = ImagePicker();
  final AppDatabase database;

  VideoBloc({required this.database}) : super(VideoInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<GenerateVideoEvent>(_onGenerateVideo);
    on<ResetEvent>(_onReset);
  }

  Future<void> _onPickImage(
      PickImageEvent event,
      Emitter<VideoState> emit,
      ) async {
    try {
      final picked = await _picker.pickImage(source: event.source);

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
      emit(VideoLoadingState(
          imageFile, event.processingMessage ?? 'Processing image...'));
      final images = await ImageService.processImage(imageFile);

      emit(VideoLoadingState(
          imageFile, event.generatingMessage ?? 'Generating video...'));
      final videoFile = await VideoService.generateVideo(images);

      if (videoFile != null) {
        // Save to database using Drift
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final videoHistory = VideoHistoryCompanion(
          videoPath: drift.Value(videoFile),
          imagePath: drift.Value(imageFile.path),
          createdAt: drift.Value(DateTime.now()),
          title: drift.Value('MOTION_$timestamp'),
        );

        await database.createVideo(videoHistory);

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