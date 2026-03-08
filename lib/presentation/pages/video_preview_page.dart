import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../core/design/design_system.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/video_preview/preview_action_bar.dart';
import '../widgets/video_preview/preview_share_sheet.dart';
import '../widgets/video_preview/video_player_view.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;

  const VideoPreviewScreen({super.key, required this.videoPath});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isSaving = false;
  bool _isVideoCompleted = false;
  bool _wasPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    await _videoPlayerController.initialize();
    _videoPlayerController.addListener(_onVideoProgress);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.accent,
        handleColor: AppColors.accent,
        backgroundColor: AppColors.surfaceHighest,
        bufferedColor: AppColors.accentBorderLight,
      ),
      placeholder: const ColoredBox(
        color: AppColors.background,
        child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      ),
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      errorBuilder: (context, errorMessage) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.lg),
            Text(errorMessage,
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    setState(() {});
  }

  void _onVideoProgress() {
    final v = _videoPlayerController.value;
    if (!v.isInitialized || v.duration == Duration.zero) return;
    if (_wasPlaying && !v.isPlaying) {
      final progress = v.position.inMilliseconds / v.duration.inMilliseconds;
      if (progress >= 0.95 && !_isVideoCompleted) {
        if (mounted) setState(() => _isVideoCompleted = true);
      }
    }
    _wasPlaying = v.isPlaying;
  }

  Future<void> _replay() async {
    await _videoPlayerController.seekTo(Duration.zero);
    await _videoPlayerController.play();
    if (mounted) setState(() => _isVideoCompleted = false);
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);
    try {
      final result = await SaverGallery.saveFile(
        filePath: widget.videoPath,
        fileName: 'fisherman_video_${DateTime.now().millisecondsSinceEpoch}',
        skipIfExists: true,
      );
      setState(() => _isSaving = false);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.isSuccess
            ? l10n.videoSavedSuccess
            : l10n.error(result.errorMessage ?? '')),
        backgroundColor: result.isSuccess ? AppColors.accent : AppColors.error,
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.error(e)),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  Future<void> _shareVideo() async {
    final l10n = AppLocalizations.of(context);
    try {
      await Share.shareXFiles([XFile(widget.videoPath)], text: l10n.shareVideoText);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.shareError(e.toString())),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onVideoProgress);
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.videoPreviewTitle, style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_outlined, color: AppColors.accent, size: 24),
            onPressed: () => showPreviewShareSheet(
              context,
              onSave: _saveToGallery,
              onShare: _shareVideo,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: VideoPlayerView(
                chewieController: _chewieController,
                isCompleted: _isVideoCompleted,
                onReplay: _replay,
              ),
            ),
            VideoPreviewActionBar(
              isSaving: _isSaving,
              onSave: _saveToGallery,
              onShare: _shareVideo,
            ),
          ],
        ),
      ),
    );
  }
}
