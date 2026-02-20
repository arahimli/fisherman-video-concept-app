import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import 'core/design/design_system.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;

  const VideoPreviewScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.error,
        handleColor: AppColors.error,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white30,
      ),
      placeholder: const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: AppColors.textPrimary)),
      ),
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: AppColors.error, size: 48),
              const SizedBox(height: AppSpacing.lg),
              Text(
                errorMessage,
                style: const TextStyle(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    setState(() {});
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? '✓ Video qalereya saxlanıldı' : 'Xəta: ${result.errorMessage ?? "Bilinməyən xəta"}'),
          backgroundColor: result.isSuccess ? AppColors.success : AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xəta: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _shareVideo() async {
    try {
      await Share.shareXFiles([XFile(widget.videoPath)], text: 'Bu videomu bax!');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paylaşma xətası: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXl),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: AppRadius.xsAll,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Videonuzu paylaşın',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xl),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(Icons.save_alt, color: AppColors.success),
                ),
                title: const Text('Qalereya saxla'),
                subtitle: const Text('Telefonun qaleresinda saxlanacaq'),
                onTap: () {
                  Navigator.pop(context);
                  _saveToGallery();
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: const Icon(Icons.share, color: AppColors.info),
                ),
                title: const Text('Paylaş'),
                subtitle: const Text('WhatsApp, Telegram və digər tətbiqlər'),
                onTap: () {
                  Navigator.pop(context);
                  _shareVideo();
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Video önizləmə'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _showShareOptions,
            tooltip: 'Paylaş',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!.videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: AppShadows.bottomSheet,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveToGallery,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save_alt),
                    label: Text(_isSaving ? 'Saxlanılır...' : 'Qalereya saxla'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareVideo,
                    icon: const Icon(Icons.send),
                    label: const Text('Paylaş'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
