part of 'bloc.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final ImagePicker _picker;
  final AppDatabase database;
  final ProcessImageFn _processImage;
  final GenerateVideoFn _generateVideo;
  final GetWatermarkFn _getWatermarkSettings;

  VideoBloc({
    required this.database,
    ImagePicker? picker,
    ProcessImageFn? processImageFn,
    GenerateVideoFn? generateVideoFn,
    GetWatermarkFn? getWatermarkSettingsFn,
  })  : _picker = picker ?? ImagePicker(),
        _processImage = processImageFn ?? ImageService.processImage,
        _generateVideo = generateVideoFn ?? _defaultGenerateVideo,
        _getWatermarkSettings =
            getWatermarkSettingsFn ?? _defaultGetWatermarkSettings,
        super(VideoInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<GenerateVideoEvent>(_onGenerateVideo);
    on<ResetEvent>(_onReset);
  }

  // Default service implementations used in production.
  static Future<String?> _defaultGenerateVideo(
    Map<String, String> images, {
    WatermarkSettings? watermark,
    VideoLanguage? language,
  }) =>
      VideoService.generateVideo(images, watermark: watermark, language: language ?? VideoLanguage.en);

  static Future<WatermarkSettings> _defaultGetWatermarkSettings() =>
      SettingsService().getWatermarkSettings();

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
      final images = await _processImage(imageFile);

      emit(VideoLoadingState(
          imageFile, event.generatingMessage ?? 'Generating video...'));
      final watermark = await _getWatermarkSettings();
      final videoFile = await _generateVideo(images, watermark: watermark, language: event.language);

      if (videoFile != null) {
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
